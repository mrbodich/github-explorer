//
//  GithubFavouritesView.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 27.03.2023.
//

import SwiftUI

struct GithubFavouritesView: View {
    @ObservedObject var viewModel: GithubFavouritesVM
    
    var body: some View {
        GithubReposView(repos: viewModel.repos,
                        favouritedIDs: [])
    }
}
