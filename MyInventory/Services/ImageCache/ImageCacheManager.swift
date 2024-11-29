//
//  ImageCache.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import Foundation
import UIKit

protocol ImageCacheProtocol {
    func getImage(forKey key: String) -> UIImage?
    func saveImage(_ image: UIImage, forKey key: String, expirationTime: TimeInterval?)
    func removeImage(forKey key: String)
    func clearCache()
}

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let memoryCache: MemoryImageCache
    private let diskCache: DiskImageCache
    
    struct CacheConfiguration {
        var memoryCountLimit: Int = 100
        var memorySizeLimit: Int = 1024 * 1024 * 100 // 100 MB
        var defaultExpirationTime: TimeInterval = 24 * 60 * 60 * 3 // (24 hours) * 3 = 3 days
    }
    
    private var configuration: CacheConfiguration
    
    private init() {
        self.configuration = CacheConfiguration()
        self.memoryCache = MemoryImageCache()
        self.diskCache = try! DiskImageCache()
        
        self.memoryCache.cache.countLimit = configuration.memoryCountLimit
        self.memoryCache.cache.totalCostLimit = configuration.memorySizeLimit
    }
    
    func configure(with config: CacheConfiguration) {
        self.configuration = config
        self.memoryCache.cache.countLimit = config.memoryCountLimit
        self.memoryCache.cache.totalCostLimit = config.memorySizeLimit
    }
    
    func getImage(forKey key: String) -> UIImage? {
        if let image = memoryCache.getImage(forKey: key) {
            return image
        }
        
        if let image = diskCache.getImage(forKey: key) {
            memoryCache.saveImage(
                image,
                forKey: key,
                expirationTime: configuration.defaultExpirationTime
            )
            return image
        }
        return nil
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        memoryCache.saveImage(
            image,
            forKey: key,
            expirationTime: configuration.defaultExpirationTime
        )
        diskCache.saveImage(
            image,
            forKey: key,
            expirationTime: configuration.defaultExpirationTime
        )
    }
    
    func clearCache() {
        memoryCache.clearCache()
        diskCache.clearCache()
    }
}
