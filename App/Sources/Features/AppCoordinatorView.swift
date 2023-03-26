//
//  AppCoordinatorView.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 25.03.2023.
//

import SwiftUI

struct AppCoordinatorView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            GithubReposCoordinatorView(
                coordinator: coordinator.githubExploreCoordinator
            )
            .tabItem {
                Label("Trending", systemImage: "chart.line.uptrend.xyaxis")
            }
            .tag(AppTab.explore)
            
            GithubReposCoordinatorView(
                coordinator: coordinator.githubExploreCoordinator
            )
                .tabItem {
                    Label("Favourites", systemImage: "star.fill")
                }
                .tag(AppTab.favourites)
        }
//        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

#if DEBUG
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppCoordinatorView(
            coordinator: .init(initialTab: .explore,
                               githubClient: MockGithubReposClient())
        )
    }
}
#endif