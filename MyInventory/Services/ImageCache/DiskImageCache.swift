//
//  DiskImageCache.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import Foundation
import UIKit


struct CachedImageMetadata: Codable {
    let timestamp: Date
    let expirationTime: TimeInterval?
}

class DiskImageCache: ImageCacheProtocol {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() throws {
        let documentsDirectory = try fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        cacheDirectory = documentsDirectory.appendingPathExtension("ImageCache")
        try createDirectoryIfNeeded()
    }
    
    private func createDirectoryIfNeeded() throws {
        guard !fileManager.fileExists(atPath: cacheDirectory.path) else { return }
        try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    private func fileURL(forKey key: String) -> URL {
        return cacheDirectory.appendingPathExtension(key)
    }
    
    private func metadataURL(forKey key: String) -> URL {
        return cacheDirectory.appendingPathExtension("\(key)_metadata.json")
    }
    
    func getImage(forKey key: String) -> UIImage? {
        let fileURL = fileURL(forKey: key)
        let metadataURL = metadataURL(forKey: key)
        
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data),
              let metadataData = try? Data(contentsOf: metadataURL),
              let metadata = try? JSONDecoder().decode(CachedImageMetadata.self, from: metadataData)
        else { return nil }
        
        if let expirationTime = metadata.expirationTime,
           Date().timeIntervalSince(metadata.timestamp) > expirationTime {
            removeImage(forKey: key)
            return nil
        }
        return image
    }
    
    func saveImage(_ image: UIImage, forKey key: String, expirationTime: TimeInterval?) {
        let fileURL = fileURL(forKey: key)
        let metadataURL = metadataURL(forKey: key)
        
        if let data = image.jpegData(compressionQuality: 0.75) {
            try? data.write(to: fileURL)
            
            let metadata = CachedImageMetadata(
                timestamp: Date(),
                expirationTime: expirationTime
            )
            
            if let metadata = try? JSONEncoder().encode(metadata) {
                try? metadata.write(to: metadataURL)
            }
        }
    }
    
    func removeImage(forKey key: String) {
        let fileURL = fileURL(forKey: key)
        let metadataURL = metadataURL(forKey: key)
        
        try? fileManager.removeItem(at: fileURL)
        try? fileManager.removeItem(at: metadataURL)
    }
    
    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? createDirectoryIfNeeded()
    }  
}
