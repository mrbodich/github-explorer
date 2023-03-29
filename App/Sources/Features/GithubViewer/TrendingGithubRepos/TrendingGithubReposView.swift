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
    
    var body: some View {
        GithubReposView(repos: viewModel.repos,
                        favouritedIDs: favouritesIDs)
    }
}
