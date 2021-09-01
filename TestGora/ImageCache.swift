//
//  ImageCache.swift
//  TestGora
//
//  Created by Александр Галкин on 01.09.2021.
//

import Foundation
import UIKit

protocol ImageCacheble {
    func image(for url: NSURL) -> UIImage?
    func insertImage(_ image: UIImage, url: NSURL)
    func exists(url: NSURL) -> Bool
}
//Класс для кэширования предоставляющий кэш размером в 100 mb
class ImageCache {
    let imageCache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.totalCostLimit = 1024*1024*100 //100mb
        cache.countLimit = 50000
        return cache
    }()
    
    private var lock: NSLock = NSLock()
}

extension ImageCache: ImageCacheble {
    //MARK: - Method for get image from cache by URL KEY
    func image(for url: NSURL) -> UIImage? {
        lock.lock()
        defer {
            lock.unlock()
        }
        return imageCache.object(forKey: url)
    }
    
    //MARK: - Method for inserting new value in cache
    func insertImage(_ image: UIImage, url: NSURL) {
        lock.lock()
        defer {
            lock.unlock()
        }
        if !exists(url: url) {
            imageCache.setObject(image, forKey: url)
            print("Im \(url) was added to cache")
        }
        
    }
    
    func exists(url: NSURL) -> Bool {
        return (imageCache.object(forKey: url) != nil) ? true : false
    }
}
