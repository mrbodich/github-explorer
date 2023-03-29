//
//  GithubResponseParser.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 27.03.2023.
//

import Foundation
import Alamofire

struct GithubResponseParser {
    func parse(header: String) -> GithubResponseDirector {
        .init(prevURL:  extractUrl(for: "prev", from: header),
              nextURL:  extractUrl(for: "next", from: header),
              lastURL:  extractUrl(for: "last", from: header),
              firstURL: extractUrl(for: "first", from: header))
    }
    
    private func extractUrl(for key: String, from string: String) -> String? {
        guard let regex = try? Regex("<(?<url>[^\";<>]*?)>; rel=\"\(key)\"", as: (Substring, url: Substring).self),
              let result = try? regex.firstMatch(in: string) else { return nil }
        return String(result.url)
    }
}

struct GithubResponseDirector {
    let prevURL: String?
    let nextURL: String?
    let lastURL: String?
    let firstURL: String?
}
