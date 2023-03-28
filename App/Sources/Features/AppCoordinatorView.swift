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
                coordinator: coordinator.githubReposCoordinator
            )
            .tabItem {
                Label("Trending", systemImage: "chart.line.uptrend.xyaxis")
            }
            .tag(AppTab.explore)
            
            GithubFavouritesView(
                viewModel: coordinator.githubFavouritesVM
            )
                .tabItem {
                    Label("Favourites", systemImage: "star.fill")
                }
                .tag(AppTab.favourites)
        }
        .didSelectGithubRepo { repoModel in
            coordinator.showGithubRepoDetails(repoModel)
        }
        .overlay(popups)
    }
    
    private var popups: some View {
        Color.clear
            .sheet(item: $coordinator.presentedGithubRepoVM) { githubRepoVM in
                GithubRepoDetailsView(viewModel: githubRepoVM)
            }
    }
}

extension View {
    func didSelectGithubRepo(_ action: @escaping (_ repoModel: GithubRepoModel) -> ()) -> some View {
        self
            .environment(\.didSelectGithubRepo, action)
    }
}

struct DidSelectGithubRepoKey: EnvironmentKey {
    static var defaultValue: ((GithubRepoModel) -> ())? = nil
}

extension EnvironmentValues {
    var didSelectGithubRepo: ((GithubRepoModel) -> ())? {
        get { self[DidSelectGithubRepoKey.self] }
        set { self[DidSelectGithubRepoKey.self] = newValue }
    }
}

#if DEBUG
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppCoordinatorView(
            coordinator: .init(initialTab: .explore,
                               githubClient: MockGithubReposClient(),
                               favouritesStore: GithubReposFavouritesStore())
        )
    }
}
#endif
