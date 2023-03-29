//
//  CachingRemoteImage.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import SwiftUI
import UIKit

struct CachingRemoteImage: View, @unchecked Sendable {
    @State private var image: UIImage?
    
    let urlStr: String
    let placeholder: ContentType
    let contentMode: ContentMode
    var imageFetcher: ImageFetcher = RemoteImageFetcher.default
    
    var body: some View {
        Color.clear.overlay {
            let content: ContentType = {
                switch (image, placeholder) {
                case let (.some(image), _): return .image(image)
                case let (.none, .image(image)): return .image(image)
                case let (.none, .color(color)): return .color(color)
                }
            }()
            
            switch content {
            case let .image(image):
                Image(uiImage: image)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case let .color(color):
                color
            }
//            .frame(width: geo.size.width, height: geo.size.height)
        }
        .clipped()
        .onAppear {
            updateImage()
        }
        .onChange(of: urlStr) { newValue in
            updateImage(urlStr: newValue)
        }
    }
    
    private func updateImage(urlStr: String? = nil) {
        let urlStr = urlStr ?? self.urlStr
        if urlStr != self.urlStr { image = nil }
        Task {
            let fetchedImage = try? await imageFetcher.fetchImage(url: urlStr)
            Task { @MainActor in
                guard urlStr == self.urlStr else { return }
                self.image = fetchedImage
            }
        }
    }
    
    enum ContentType {
        case image(UIImage)
        case color(Color)
    }
}

#if DEBUG
struct CachingRemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            CachingRemoteImage(urlStr: "https://avatars.githubusercontent.com/u/108380?v=4",
                               placeholder: .color(.gray),
                               contentMode: .fill)
            .border(Color.red)
            
            CachingRemoteImage(urlStr: "https://avatars.githubusercontent.com/u/108380?v=4",
                               placeholder: .color(.gray),
                               contentMode: .fill,
                               imageFetcher: RemoteImageFetcher(sid: "com.test1",
                                                                memoryCacheCapacity: 0,
                                                                diskCacheCapacity: 0))
            .border(Color.green)
            
            CachingRemoteImage(urlStr: "https://avatars.githubusercontent.com/u/108380?v=4",
                               placeholder: .color(.gray),
                               contentMode: .fill,
                               imageFetcher: RemoteImageFetcher(sid: "com.test2",
                                                                memoryCacheCapacity: 10,
                                                                diskCacheCapacity: 0))
            .border(Color.blue)
            
            CachingRemoteImage(urlStr: "https://avatars.githubusercontent.com/u/108380?v=4",
                               placeholder: .color(.gray),
                               contentMode: .fit,
                               imageFetcher: RemoteImageFetcher(sid: "com.test3",
                                                                memoryCacheCapacity: 0,
                                                                diskCacheCapacity: 10))
            .border(Color.orange)
            
            CachingRemoteImage(urlStr: "https://avatars.githubusercontent.com/u/108380?v=4",
                               placeholder: .color(.gray),
                               contentMode: .fill,
                               imageFetcher: RemoteImageFetcher(sid: "com.test3",
                                                                memoryCacheCapacity: 0,
                                                                diskCacheCapacity: 0))
            .border(Color.purple)
        }
    }
}
#endif
