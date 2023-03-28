//
//  GithubReposFavouritesStore.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 28.03.2023.
//

import Foundation

class GithubReposFavouritesStore: ObservableObject {
    @Published var favouritedGithubRepoIDs: Set<UInt> = []
}
