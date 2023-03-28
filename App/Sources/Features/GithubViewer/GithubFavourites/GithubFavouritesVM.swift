//
//  GithubFavouritesVM.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 27.03.2023.
//

import Foundation

final class GithubFavouritesVM: ObservableObject {
    @Published var repos: [GithubRepoModel] = []
    @Published var favouritedIDs: Set<UInt> = []
}
