//
//  GithubFavouritesVM.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 27.03.2023.
//

import Foundation

final class GithubFavouritesVM: ObservableObject {
    weak private var favouritesStore: GithubReposFavouritesStore?
    
    @Published var repos: [GithubRepoModel] = []

    init(favouritesStore: GithubReposFavouritesStore) {
        self.favouritesStore = favouritesStore
        subscribe()
    }
    
    private func subscribe() {
        favouritesStore?.$favouritedGithubRepos
            .receive(on: DispatchQueue.main)
            .assign(to: &$repos)
    }
}
