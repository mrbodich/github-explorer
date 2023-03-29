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
    @Published var favouritedGithubReposIDs: Set<UInt> = []
    
    let githubReposCoordinator: GithubReposCoordinator
    let githubFavouritesVM: GithubFavouritesVM
    let favouritesStore: GithubReposFavouritesStore
    
    init(initialTab: AppTab, githubClient: GithubReposClient, favouritesStore: GithubReposFavouritesStore) {
        self.selectedTab = initialTab
        githubReposCoordinator = .init(githubClient: githubClient)
        self.favouritesStore = favouritesStore
        githubFavouritesVM = .init(favouritesStore: favouritesStore)
        
        subscribe()
    }
    
    private func subscribe() {
        favouritesStore.$favouritedGithubRepoIDs
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$favouritedGithubReposIDs)
    }
    
    func showGithubRepoDetails(_ repoModel: GithubRepoModel) {
        presentedGithubRepoVM = .init(model: repoModel,
                                      favouritesStore: favouritesStore)
        presentedGithubRepoVM?.delegate = self
    }
    
}

extension AppCoordinator: GithubRepoDetailsDelegate {
    func repoDidFavourited(_ repo: GithubRepoModel) {
        favouritesStore.add(githubRepoModel: repo)
    }
    
    func repoDidRemoveFromFavourites(withId id: UInt) {
        favouritesStore.remove(repoWithId: id)
    }
}
