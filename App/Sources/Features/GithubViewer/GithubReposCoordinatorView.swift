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
            GithubReposView(repos: [.init(id: 0,
                                          name: "ver-useful-repo",
                                          owner: .init(login: "John Smith", avatarUrl: "https://avatars.githubusercontent.com/u/9919?s=200&v=4"),
                                          description: "让生产力加倍的 ChatGPT 快捷指令，按照领域和功能分区，可对提示词进行标签筛选、关键词搜索和一键复制。",
                                          stargazersCount: 4195)],
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
