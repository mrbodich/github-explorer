//
//  GithubExplorerApp.swift
//  Github Explorer
//
//  Created by Bogdan Chornobryvets on 25.03.2023.
//

import SwiftUI

@main
struct GithubExplorerApp: SwiftUI.App {
    @StateObject var appCoordinator = AppCoordinator(initialTab: .explore,
                                                     githubClient: MockGithubReposClient())
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: appCoordinator)
        }
    }
}
