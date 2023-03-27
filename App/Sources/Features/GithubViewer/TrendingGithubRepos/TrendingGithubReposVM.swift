//
//  TrendingGithubReposVM.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 27.03.2023.
//

import Foundation

final class TrendingGithubReposVM: ObservableObject {
    @Published var repos: [GithubRepoModel] = []
    
    
}
