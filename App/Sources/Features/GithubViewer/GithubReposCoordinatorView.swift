//
//  GithubReposCoordinatorView.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import SwiftUI

struct GithubReposCoordinatorView: View {
    @ObservedObject var coordinator: GithubReposCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            RoundedTabs(selectedTab: $coordinator.selectedTab,
                        tabs: [.day, .week, .month])
            .padding(.horizontal, 20)
            GithubReposView(repos: coordinator.repos,
                            favouritedIDs: [])
            .refreshable {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }
}

#if DEBUG
struct GithubReposCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        GithubReposCoordinatorView(
            coordinator: .init(
                githubClient: MockGithubReposClient()
            )
        )
    }
}
#endif
