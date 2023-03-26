//
//  AppCoordinator.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import Foundation

enum AppTab: Hashable {
    case explore, favourites
}

class AppCoordinator: ObservableObject {
    @Published var selectedTab: AppTab
    
    @Published private(set) var githubExploreCoordinator: GithubReposCoordinator
    
    init(initialTab: AppTab, githubClient: GithubReposClient) {
        self.selectedTab = initialTab
        githubExploreCoordinator = .init(githubClient: githubClient)
    }
    
}
