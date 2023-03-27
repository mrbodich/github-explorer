//
//  GithubReposClient.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 25.03.2023.
//

import Foundation

protocol GithubReposClient {
    @Sendable func fetch(after date: Date) async throws -> [GithubRepoModel]
    func fetchNext() async throws -> [GithubRepoModel]?
}

struct MockGithubReposClient: GithubReposClient {
    func fetch(after date: Date) async throws -> [GithubRepoModel] {
        (0..<5)
            .map {
                .init(id: $0,
                      name: String.random(of: 10),
                      owner: .init(login: "John Smith", avatarUrl: ""),
                      description: "让生产力加倍的 ChatGPT 快捷指令，按照领域和功能分区，可对提示词进行标签筛选、关键词搜索和一键复制。",
                      stargazersCount: 4195,
                      createdAt: "")
            }
    }
    
    func fetchNext() async throws -> [GithubRepoModel]? {
        nil
    }
}

