//
//  TrendingGithubReposVM.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 27.03.2023.
//

import Foundation

final class TrendingGithubReposVM: ObservableObject {
    private let githubClient: GithubReposClient
    private var lastLoadedDate: Date? = nil
    
    @Published var repos: [GithubRepoModel] = []
    @Published var favouritedIDs: Set<UInt> = []
    
    init(githubClient: GithubReposClient) {
        self.githubClient = githubClient
    }
    
    @MainActor
    func refresh(for date: Date) async throws {
        lastLoadedDate = date
        let repos = try await githubClient.fetch(after: date)
        self.repos = repos
    }
    
    @MainActor
    func refresh() async throws {
        guard let lastLoadedDate else { return }
        try await refresh(for: lastLoadedDate)
    }
    
    @MainActor
    func loadMore() async throws {
        if let nextRepos = try await githubClient.fetchNext() {
            let uniqueRepos = nextRepos
                .filter { newRepo in !self.repos.contains { $0.id == newRepo.id } }
            self.repos.append(contentsOf: uniqueRepos)
        }
    }
    
}
