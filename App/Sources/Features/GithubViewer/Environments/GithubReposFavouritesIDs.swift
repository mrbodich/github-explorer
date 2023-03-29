//
//  GithubReposFavouritesIDs.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 29.03.2023.
//

import Foundation

import SwiftUI

struct GithubReposFavouritesIDsKey: EnvironmentKey {
    static var defaultValue: Set<UInt> = []
}

extension EnvironmentValues {
    var githubReposFavouritesIDs: Set<UInt> {
        get { self[GithubReposFavouritesIDsKey.self] }
        set { self[GithubReposFavouritesIDsKey.self] = newValue }
    }
}
