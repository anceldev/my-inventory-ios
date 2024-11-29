//
//  MemoryCache.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import Foundation
import UIKit

class CachedImage {
    let image: UIImage
    let timestamp: Date
    let expirationTime: TimeInterval?
    
    init(image: UIImage, timestamp: Date, expirationTime: TimeInterval? = nil) {
        self.image = image
        self.timestamp = timestamp
        self.expirationTime = expirationTime
    }
}

class MemoryImageCache: ImageCacheProtocol {
//    private let cache = NSCache<NSString, CachedImage>()
    
    let cache = NSCache<NSString, CachedImage>()
    
    init() {
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clearCacheOnMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    @objc private func clearCacheOnMemoryWarning() {
        clearCache()
    }
    
    func getImage(forKey key: String) -> UIImage? {
        guard let cachedImage = cache.object(forKey: key as NSString) else { return nil }
        
        if let expirationTime = cachedImage.expirationTime,
           Date().timeIntervalSince(cachedImage.timestamp) > expirationTime {
            removeImage(forKey: key)
            return nil
        }
        return cachedImage.image
    }
    
    func saveImage(_ image: UIImage, forKey key: String, expirationTime: TimeInterval?) {
        let cachedImage = CachedImage(
            image: image,
            timestamp: Date(),
            expirationTime: expirationTime
        )
        cache.setObject(cachedImage, forKey: key as NSString)
    }
    
    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
