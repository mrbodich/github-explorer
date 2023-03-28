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
    @Published var presentedGithubRepoVM: GithubRepoDetailsVM?
    
    let githubReposCoordinator: GithubReposCoordinator
    let githubFavouritesVM: GithubFavouritesVM
    let favouritesStore: GithubReposFavouritesStore
    
    init(initialTab: AppTab, githubClient: GithubReposClient, favouritesStore: GithubReposFavouritesStore) {
        self.selectedTab = initialTab
        githubReposCoordinator = .init(githubClient: githubClient)
        self.favouritesStore = favouritesStore
        githubFavouritesVM = .init()
    }
    
    func showGithubRepoDetails(_ repoModel: GithubRepoModel) {
        presentedGithubRepoVM = .init(model: repoModel,
                                      favouritesStore: favouritesStore)
    }
    
}
