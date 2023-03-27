//
//  GithubReposCoordinator.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import Foundation
import Combine

class GithubReposCoordinator: ObservableObject {
    private let githubClient: GithubReposClient
    private var bucket: Set<AnyCancellable> = []
    
    @Published var selectedTab: GithubTab? = .day
    @Published var repos: [GithubRepoModel] = []
    
    init(githubClient: GithubReposClient) {
        self.githubClient = githubClient
        
        subscribe()
    }
    
    private func subscribe() {
        $selectedTab
            .sink { [weak self] tab in
                self?.tabDidSelect(tab)
            }
            .store(in: &bucket)
    }
    
    private func tabDidSelect(_ tab: GithubTab?) {
        guard let tab, let targetDate = getDate(for: tab) else { return }
        Task { @MainActor [weak self] in
            let repos = try await githubClient.fetch(after: targetDate)
            self?.repos = repos
        }
    }
    
    //Fabric method for getting edge date
    private func getDate(for tab: GithubTab) -> Date? {
        switch tab {
        case .month: return Calendar.current.date(byAdding: .day, value: -30, to: Date())
        case .week: return Calendar.current.date(byAdding: .day, value: -7, to: Date())
        case .day: return Calendar.current.date(byAdding: .day, value: -0, to: Date())
        }
    }
    
}
