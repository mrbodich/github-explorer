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
    
    private(set) var githubReposCoordinator: GithubReposCoordinator
    private(set) var githubFavouritesVM: GithubFavouritesVM
    
    init(initialTab: AppTab, githubClient: GithubReposClient) {
        self.selectedTab = initialTab
        githubReposCoordinator = .init(githubClient: githubClient)
        githubFavouritesVM = .init()
    }
    
}
