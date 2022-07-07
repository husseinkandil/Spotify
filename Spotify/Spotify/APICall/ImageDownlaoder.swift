//
//  ImageDownlaoder.swift
//  Spotify
//
//  Created by Hussein Kandil on 07/07/2022.
//

import Foundation
import UIKit

final class ImageDownlaoder {
    
    static let shared = ImageDownlaoder()
    
    private var cachedImages: [String: UIImage]
    private var imagesDownloadTasks: [String: URLSessionDataTask]
    
    let serialQueueForImages = DispatchQueue(label: "images.queue", attributes: .concurrent)
    let serialQueueForDataTasks = DispatchQueue(label: "dataTasks.queue", attributes: .concurrent)
    
    private init() {
        cachedImages = [:]
        imagesDownloadTasks = [:]
    }
    
    func downloadImage(url: String?,
                       completionHandler: @escaping (UIImage?, Bool) -> Void,
                       placeholderImage: UIImage?) {
        
        guard let urlString = url else {
            completionHandler(placeholderImage, true)
            return
        }
        
        if let image = getCachedImageFrom(urlString: urlString) {
            completionHandler(image, true)
        } else {
            guard let url = URL(string: urlString) else {
                completionHandler(placeholderImage, true)
                return
            }
            
            if let _ = getDataTaskFrom(urlString: urlString) {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else {
                    return
                }
                
                if let _ = error {
                    DispatchQueue.main.async {
                        completionHandler(placeholderImage, true)
                    }
                    return
                }
                
                let image = UIImage(data: data)
                
                self.serialQueueForImages.sync(flags: .barrier) {
                    self.cachedImages[urlString] = image
                }
                
                _ = self.serialQueueForDataTasks.sync(flags: .barrier) {
                    self.imagesDownloadTasks.removeValue(forKey: urlString)
                }
                
                DispatchQueue.main.async {
                    completionHandler(image, false)
                }
            }
            
            self.serialQueueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks[urlString] = task
            }
            
            task.resume()
        }
    }
    
    
    private func getCachedImageFrom(urlString: String) -> UIImage? {
        
        serialQueueForImages.sync {
            return cachedImages[urlString]
        }
    }
    
    private func getDataTaskFrom(urlString: String) -> URLSessionTask? {
        
        serialQueueForDataTasks.sync {
            return imagesDownloadTasks[urlString]
        }
    }
}
