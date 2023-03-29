//
//  SnakeCaseJSONDecoder.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 25.03.2023.
//

import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
