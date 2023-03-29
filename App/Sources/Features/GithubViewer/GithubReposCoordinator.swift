//
//  GithubReposCoordinator.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import Foundation
import Combine

class GithubReposCoordinator: ObservableObject {
    private var bucket: Set<AnyCancellable> = []
    
    @Published var selectedTab: GithubTab? = .day
    private(set) var reposVM: TrendingGithubReposVM
    @Published var isRefreshing: Bool = false
    
    init(githubClient: GithubReposClient) {
        reposVM = .init(githubClient: githubClient)
        
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
            self?.isRefreshing = true
            try? await self?.reposVM.refresh(for: targetDate)
            self?.isRefreshing = false
        }
    }
    
    //Fabric method for getting edge date
    private func getDate(for tab: GithubTab) -> Date? {
        switch tab {
        case .month: return Calendar.current.date(byAdding: .month, value: -1, to: Date())
        case .week: return Calendar.current.date(byAdding: .day, value: -7, to: Date())
        case .day: return Calendar.current.date(byAdding: .day, value: -1, to: Date())
        }
    }
    
}
