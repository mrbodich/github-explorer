//
//  GithubReposCoordinator.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import Foundation

class GithubReposCoordinator: ObservableObject {
    private let githubClient: GithubReposClient
    
    @Published var selectedTab: GithubTab? = .day
    
    init(githubClient: GithubReposClient) {
        self.githubClient = githubClient
    }
    
}
