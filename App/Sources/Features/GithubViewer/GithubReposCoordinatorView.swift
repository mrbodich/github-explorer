//
//  GithubReposCoordinatorView.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import SwiftUI

struct GithubReposCoordinatorView: View {
    @ObservedObject var coordinator: GithubReposCoordinator
    @State var isLoadingMore: Bool = false
    @State var isManuallyRefreshing: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                TrendingGithubReposView(viewModel: coordinator.reposVM)
                    .refreshable {
                        isManuallyRefreshing = true
                        try? await coordinator.reposVM.refresh()
                        isManuallyRefreshing = false
                    }
                    .infiniteScrollable {
                        guard !coordinator.isRefreshing else { return }
                        isLoadingMore = true
                        try? await coordinator.reposVM.loadMore()
                        isLoadingMore = false
                    }
                    .opacity(coordinator.isRefreshing ? 0.38 : 1)
                    .animation(.easeInOut, value: coordinator.isRefreshing)
                    .overlay {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .opacity(coordinator.isRefreshing ? 1 : 0)
                            .animation(.easeInOut, value: coordinator.isRefreshing)
                    }
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            RoundedTabs(selectedTab: $coordinator.selectedTab,
                                        tabs: [.day, .week, .month])
                            .padding(.horizontal, 20)
                            .frame(width: proxy.size.width)
                            .disabled(isLoadingMore)
                            .disabled(isManuallyRefreshing)
                        }
                    }
            }
            .disabled(coordinator.isRefreshing)
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
