//
//  ImageFetcherTests.swift
//  GithubExplorerTests
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import XCTest
@testable import GithubExplorer

final class ImageFetcherTests: XCTestCase {
    private let memoryCachingID = "com.test.memorycaching"
    private let diskCachingID = "com.test.diskcaching"
    
    var memoryCachingFetcher: RemoteImageFetcher!
    var diskCachingFetcher: RemoteImageFetcher!

    override func setUpWithError() throws {
        memoryCachingFetcher = RemoteImageFetcher(sid: memoryCachingID, memoryCacheCapacity: 50, diskCacheCapacity: 0)
        diskCachingFetcher = RemoteImageFetcher(sid: diskCachingID, memoryCacheCapacity: 0, diskCacheCapacity: 50)
    }

    override func tearDownWithError() throws {
        memoryCachingFetcher = RemoteImageFetcher(sid: memoryCachingID, memoryCacheCapacity: 0, diskCacheCapacity: 0)
        diskCachingFetcher = RemoteImageFetcher(sid: diskCachingID, memoryCacheCapacity: 0, diskCacheCapacity: 0)
        memoryCachingFetcher = nil
        diskCachingFetcher = nil
    }

    func testRemoteImageFetcherInMemory() async throws {
        //given
        let url = "https://avatars.githubusercontent.com/u/108380?v=4"
        
        //when
        let image1 = try await memoryCachingFetcher.fetchImage(url: url)
        let image2 = try await memoryCachingFetcher.fetchImage(url: url)
        
        //then
        XCTAssertNotNil(image1, "Error fetching image from url: \(url)")
        XCTAssertNotNil(image2, "Error fetching image from url: \(url)")
        XCTAssert(image1 === image2, "One single URL returned 2 different UIImage objects (the second one from memory cache)")
    }

}
