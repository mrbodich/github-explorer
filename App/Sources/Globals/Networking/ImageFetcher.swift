//
//  ImageFetcher.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import Foundation
import UIKit
import AlamofireImage

protocol ImageFetcher {
    func fetchImage(url: String) async throws -> UIImage
}

actor RemoteImageFetcher: ImageFetcher {
    private var fetchingTasks: [URLRequest: Task<UIImage, Error>] = [:]
    private let urlSession: URLSession
    private let imageCache: AutoPurgingImageCache
    private let urlCache: URLCache
    private var screenScale: CGFloat! = nil
    private let semaphore = AsyncSemaphore(count: 20)
    
    static var `default`: RemoteImageFetcher = .init(sid: "com.githubexplorer.imageremotefetcher", memoryCacheCapacity: 100, diskCacheCapacity: 150)
    
    init(sid: String, memoryCacheCapacity: Int, diskCacheCapacity: Int) {
        let totalMemoryCapacity = memoryCacheCapacity * 1024 * 1024
        let imageMemoryCapacity = totalMemoryCapacity / 4 * 3
        
        let dataMemoryCapacity = totalMemoryCapacity / 4 * 1
        let diskCapacity = diskCacheCapacity * 1024 * 1024
        
        //Initializing Caches
        imageCache = .init(memoryCapacity: UInt64(imageMemoryCapacity),
                           preferredMemoryUsageAfterPurge: UInt64(imageMemoryCapacity / 2))
        urlCache = URLCache(memoryCapacity: dataMemoryCapacity,
                            diskCapacity: diskCapacity,
                            diskPath: sid)
        
        let urlSessionConfiguration = RemoteImageFetcher.defaultURLSessionConfiguration()
        urlSession = URLSession(configuration: urlSessionConfiguration)
    }
    
    func fetchImage(url urlStr: String) async throws -> UIImage {
        guard let url = URL(string: urlStr) else { throw URLError(.badURL) }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("max-age=172800", forHTTPHeaderField: "Cache-Control")
        
        if let existingTask = fetchingTasks[urlRequest] {
            return try await existingTask.value
        }
        
        if screenScale == nil {
            screenScale = await UIScreen.main.scale
        }
        let scale = screenScale!
        
        if let cachedImage = imageCache.image(for: urlRequest) {
            return cachedImage
        }
        
        if let imageData = urlCache.cachedResponse(for: urlRequest)?.data,
           let cachedImage = UIImage(data: imageData) {
            return cachedImage
        }
        
        let task: Task<UIImage, Error> = Task {
            await semaphore.wait()
            do {
                let (imageData, urlResponse) = try await urlSession.isolatedData(for: urlRequest)
                await semaphore.release()
                
                let image: UIImage?
                image = UIImage(data: imageData, scale: scale)
                
                guard let image else { throw URLError(.cannotDecodeContentData) }
                
                imageCache.add(image, for: urlRequest)
                
                //Saving manually because github returns Cache-Control: no-cache in the response
                let cachedResponse = CachedURLResponse(response: urlResponse, data: imageData)
                urlCache.storeCachedResponse(cachedResponse, for: urlRequest)
                
                return image
            } catch {
                await semaphore.release()
                throw error
            }
        }
        
        fetchingTasks[urlRequest] = task
        
        defer {
            fetchingTasks.removeValue(forKey: urlRequest)
        }
        
        return try await task.value
    }
    
    private static func defaultURLSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        
        configuration.httpShouldSetCookies = true
        configuration.httpShouldUsePipelining = false

        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 60
        
        return configuration
    }
    
}
