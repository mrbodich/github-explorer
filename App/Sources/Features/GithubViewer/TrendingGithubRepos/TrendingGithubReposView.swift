//
//  TrendingGithubReposView.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 28.03.2023.
//

import SwiftUI

struct TrendingGithubReposView: View {
    @ObservedObject var viewModel: TrendingGithubReposVM
    @Environment(\.githubReposFavouritesIDs) var favouritesIDs
    @Environment(\.goToFavoritesDidPress) var goToFavorites
    
    var body: some View {
        switch viewModel.isFetchedWithError {
        case false:
            GithubReposView(repos: viewModel.repos,
                            favouritedIDs: favouritesIDs)
        case true:
            FailedLoadingView {
                goToFavorites?()
            }
        }
    }
}
