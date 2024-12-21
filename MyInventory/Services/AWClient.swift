//
//  AppwriteClient.swift
//  MyInventory
//
//  Created by Ancel Dev account on 27/11/24.
//

import Appwrite
import Foundation
import JSONCodable
import Logging
import SwiftUI

var logger = Logger(label: "Logger")

enum AWConfig: String {
    case endpoint
    case project
    case database
    
    var id: String {
        switch self {
        case .endpoint: "https://cloud.appwrite.io/v1"
        case .project:  Bundle.main.infoDictionary?["AW_PROJECT_ID"] as? String ?? ""
        case .database: Bundle.main.infoDictionary?["AW_DATABASE_ID"] as? String ?? ""
        }
    }
}

enum AWBucket {
    case itemsBucket
    case profilesBucket
    case backdropBuckets
    
    var id: String {
        switch self {
        case .itemsBucket:      Bundle.main.infoDictionary?["AW_ITEMS_BUCKET_ID"] as? String ?? ""
        case .profilesBucket:   Bundle.main.infoDictionary?["AW_PROFILES_BUCKET_ID"] as? String ?? ""
        case .backdropBuckets:  Bundle.main.infoDictionary?["AW_BACKDROPS_BUCKET_ID"] as? String ?? ""
        }
    }
}

enum AWCollection {
    case users
    case inventories
    case boxes
    case items
    case suggestions
    
    var id: String {
        switch self {
        case .items:        Bundle.main.infoDictionary?["AW_ITEMS_COLLECTION_ID"] as? String ?? ""
        case .users:        Bundle.main.infoDictionary?["AW_USERS_COLLECTION_ID"] as? String ?? ""
        case .inventories:  Bundle.main.infoDictionary?["AW_INVENTORIES_COLLECTION_ID"] as? String ?? ""
        case .boxes:        Bundle.main.infoDictionary?["AW_BOXES_COLLECTION_ID"] as? String ?? ""
        case .suggestions:  Bundle.main.infoDictionary?["AW_SUGGESTIONS_COLLECTION_ID"] as? String ?? ""
        }
    }
}

struct AWClient {
    let client: Client
    let database: Databases
    let account: Account
    let storage: Appwrite.Storage
    
    private init() {
        self.client = Client()
            .setEndpoint(AWConfig.endpoint.id)
            .setProject(AWConfig.project.id)
        self.database = Databases(self.client)
        self.account = Account(self.client)
        self.storage = Storage(self.client)
    }
    
    /// Gets a document from appwrite and decodes it to the specified model
    /// - Parameters:
    ///   - collection: model's collection
    ///   - id: document ID
    /// - Returns: Model
    static func getModel<T:Codable>(collection: AWCollection, id: String) async throws -> T {
        do {
            let document = try await AWClient.shared.database.getDocument(
                databaseId: AWConfig.database.id,
                collectionId: collection.id,
                documentId: id
            )
            let documentData = try convertToData(document.data)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let model = try decoder.decode(T.self, from: documentData)
            return model
        } catch {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
    
    static func getModels<T:Codable>(collection: AWCollection) async throws -> [T] {
        do {
            let documents = try await AWClient.shared.database.listDocuments(
                databaseId: AWConfig.database.id,
                collectionId: collection.id
            )
            let documentsData = try documents.documents.map { doc in
                try convertToData(doc.data)
            }
            let decoder = JSONDecoder()
            let models = try documentsData.map { data in
                try decoder.decode(T.self, from: data)
            }
            return models
        } catch {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
    
    
    static func getModelsWithQuery<T: Codable>(collection: AWCollection, queries: [String]) async throws -> [T] {
        do {
            let documents = try await AWClient.shared.database.listDocuments(
                databaseId: AWConfig.database.id,
                collectionId: collection.id,
                queries: queries
            )
            return try documents.documents.map { doc in
                let data = try convertToData(doc.data)
                return try JSONDecoder().decode(T.self, from: data)
            }
        } catch {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
    
    /// Creates a document from a model
    /// - Parameters:
    ///   - collection: model's collection
    ///   - model: model
    static func createDocument<T: Codable & Identifiable>(collection: AWCollection, model: T) async throws {
        do {
            let data = try convertToJsonString(model)
            _ = try await AWClient.shared.database.createDocument(
                databaseId: AWConfig.database.id,
                collectionId: collection.id,
                documentId: model.id as! String,
                data: data
            )
        } catch {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
    
    static func updateDocument<T: Codable & Identifiable>(collection: AWCollection, model: T, docId: String) async throws {
        do {
            let jsonData = try convertToJsonString(model)
            print(jsonData)
            let _ = try await AWClient.shared.database.updateDocument(
                databaseId: AWConfig.database.id,
                collectionId: collection.id,
                documentId: docId,
                data: jsonData
            )
        } catch {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
    
    static func updateDocumentData(collection: AWCollection, data: String, docId: String) async throws {
        do {
            _ = try await AWClient.shared.database.updateDocument(
                databaseId: AWConfig.database.id,
                collectionId: collection.id,
                documentId: docId,
                data: data
            )
        } catch  {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
    
//    static func updateDocument
    
    
    /// Uploads an Image to Appwrite and saves it on cache using `ImageCacheManager`
    /// - Parameters:
    ///   - bucket: image's bucket
    ///   - image:
    @MainActor
    static func uploadImage(bucket: AWBucket, image: Image) async throws {
        do {
            let renderer = ImageRenderer(content: image)
            guard let uiImage = renderer.uiImage else {
                print("Can't create UIImage")
                return
            }
            guard let imageData = uiImage.jpegData(compressionQuality: 0.75) else {
                print("Can't create image data form UIImage")
                return
            }
            let fileId = ID.unique()
            let _ = try await AWClient.shared.storage.createFile(
                bucketId: bucket.id,
                fileId: fileId,
                file: InputFile.fromData(
                    imageData,
                    filename: fileId,
                    mimeType: "image/jpeg"
                )
            )
            ImageCacheManager.shared.saveImage(uiImage, forKey: fileId)
            
        } catch {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
    
    
    /// Downloads and cache an Image. At first it search on cache to get the image, if it's not, it gets the image from Appwrite and saves it on cache.
    /// - Parameters:
    ///   - bucket: image's bucket
    ///   - imageId: image ID
    /// - Returns: Image if it's founded, nil if not
    static func downloadAndCacheImage(for bucket: AWBucket, imageId: String) async -> Image? {
        if let cachedImage = ImageCacheManager.shared.getImage(forKey: imageId) {
            return Image(uiImage: cachedImage)
        }
        
        do {
            let awImage = try await AWClient.shared.storage.getFilePreview(
                bucketId: bucket.id,
                fileId: imageId
            )
            let dataImage = Data(buffer: awImage)
            guard let uiImage = UIImage(data: dataImage) else { return nil }
            ImageCacheManager.shared.saveImage(uiImage, forKey: imageId)
            return Image(uiImage: uiImage)
        } catch {
            logger.error("\(error.localizedDescription)")
            return nil
        }
    }
}

extension AWClient {
    static var shared = AWClient()
}
