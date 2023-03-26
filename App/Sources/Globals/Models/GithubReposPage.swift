//
//  GithubReposPage.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 25.03.2023.
//

import Foundation

struct GithubReposPage: Decodable {
    let totalCount: UInt16
    let incompleteResults: Bool
    let items: [GithubRepoModel]
}
