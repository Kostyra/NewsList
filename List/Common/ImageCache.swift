//
//  ImageCache.swift
//  List
//
//  Created by Kos on 11.12.2024.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        if cache.object(forKey: key as NSString) == nil {
            cache.setObject(image, forKey: key as NSString)
        }
    }
}
