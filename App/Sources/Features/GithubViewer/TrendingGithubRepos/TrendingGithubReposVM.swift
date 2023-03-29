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
    @Published var isFetchedWithError: Bool = false
    
    init(githubClient: GithubReposClient) {
        self.githubClient = githubClient
    }
    
    @MainActor
    func refresh(for date: Date) async throws {
        lastLoadedDate = date
        do {
            let repos = try await githubClient.fetch(after: date)
            isFetchedWithError = false
            self.repos = repos
        } catch {
            isFetchedWithError = true
            throw error
        }
    }
    
    @MainActor
    func refresh() async throws {
        guard let lastLoadedDate else { return }
        try await refresh(for: lastLoadedDate)
    }
    
    @MainActor
    func loadMore() async throws {
        guard !isFetchedWithError else { return }
        if let nextRepos = try await githubClient.fetchNext() {
            let uniqueRepos = nextRepos
                .filter { newRepo in !self.repos.contains { $0.id == newRepo.id } }
            self.repos.append(contentsOf: uniqueRepos)
        }
    }
    
}
