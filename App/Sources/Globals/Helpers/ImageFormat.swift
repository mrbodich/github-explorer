//
//  ImageFormat.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import Foundation

extension Data {
    var imageFormat: ImageFormat? {
        guard self.count > 8 else { return nil }
        var buffer = [UInt8](repeating: 0, count: 8)
        self.copyBytes(to: &buffer, count: 8)
        
        return ImageFormat.allCases
            .first { format in
                format.header == Array(buffer.prefix(upTo: format.header.count))
            }
    }
}

enum ImageFormat: CaseIterable {
    case jpg, png, gif
    
    fileprivate var header: [UInt8] {
        switch self {
        case .png: return [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A] //0x89504E47_0D0A1A0A
        case .jpg: return [0xFF, 0xD8, 0xFF] //0xFFD8FF00_00000000
        case .gif: return [0x47, 0x49, 0x46] //0x474946
        }
    }
}
