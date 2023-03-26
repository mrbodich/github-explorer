//
//  GithubRepoModel.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 25.03.2023.
//

import Foundation

struct GithubRepoModel: Decodable, Identifiable {
    let id: UInt
    let name: String
    let owner: GithubRepoOwner
    let description: String?
    let stargazersCount: UInt
}

struct GithubRepoOwner: Decodable {
    let login: String
    let avatarUrl: String
}
