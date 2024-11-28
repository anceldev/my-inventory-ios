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
        case .project: Bundle.main.infoDictionary?["AW_PROJECT_ID"] as? String ?? ""
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
    
    var id: String {
        switch self {
        case .items: Bundle.main.infoDictionary?["AW_PROJECT_ID"] as? String ?? ""
        case .users: Bundle.main.infoDictionary?["AW_DATABASE_ID"] as? String ?? ""
        case .inventories: Bundle.main.infoDictionary?["AW_INVENTORIES_COLLECTION_ID"] as? String ?? ""
        case .boxes: Bundle.main.infoDictionary?["6747ac0000348079a0a9"] as? String ?? ""
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
    static func createDocument(collection: AWCollection, documentId: String, data: String) async throws {
        do {
            _ = try await AWClient.shared.database.createDocument(
                databaseId: AWConfig.database.id,
                collectionId: collection.id,
                documentId: documentId,
                data: data
            )
        } catch {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    static func uploadImage(bucket: AWBucket, image: Image) async throws {
        do {
            let renderer = ImageRenderer(content: image)
            guard let uiImage = renderer.uiImage else {
                print("Cant upload image")
                return
            }
            guard let imageData = uiImage.jpegData(compressionQuality: 0.7) else {
                print("Can't create data from image")
                return
            }
            let fileId = ID.unique()
            let file = try await AWClient.shared.storage.createFile(
                bucketId: bucket.id,
                fileId: fileId,
                file: InputFile.fromData(
                    imageData,
                    filename: fileId,
                    mimeType: "image/jpeg"
                )
            )
        } catch {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
    
}

extension AWClient {
    static var shared = AWClient()
}
