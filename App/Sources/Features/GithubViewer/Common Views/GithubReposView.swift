//
//  GithubViewerView.swift
//  Github Explorer
//
//  Created by Bogdan Chornobryvets on 25.03.2023.
//

import SwiftUI

struct GithubReposView: View {
    let repos: [GithubRepoModel]
    let favouritedIDs: Set<UInt>
    
    @State private var isLodaingMore: Bool = false
    @Environment(\.infiniteScrollable) var _onReachEnd
    @Environment(\.didSelectGithubRepo) var didSelectGithubRepo
    
    init(repos: [GithubRepoModel], favouritedIDs: Set<UInt>) {
        self.repos = repos
        self.favouritedIDs = favouritedIDs
    }
    
    var body: some View {
        GeometryReader { outerProxy in
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        Color.clear.frame(height: 1).id("top_item")
                        ForEach(repos) { repo in
                            Button {
                                didSelectGithubRepo?(repo)
                            } label: {
                                GithubRepoCellView(model: repo,
                                                   isFavourited: favouritedIDs.contains(repo.id))
                            }
                            .buttonStyle(ScalingButtonStyle())
                        }
                        
                        if isLodaingMore {
                            ProgressView()
                                .padding(.bottom, 10)
                                .padding(.top, 15)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .background {
                        GeometryReader { proxy in
                            Color.clear.preference(key: OffsetPreferenceKey.self,
                                                   value: .init(offset: -proxy.frame(in: .named("GithubReposScrollViewOrigin")).origin.y,
                                                                maxOffset: proxy.size.height - outerProxy.size.height))
                            
                        }
                    }
                }
                .onChange(of: repos.first?.id) { _ in
                    withAnimation(.easeInOut) {
                        scrollProxy.scrollTo("top_item")
                    }
                }
                .onPreferenceChange(OffsetPreferenceKey.self,
                                    perform: onOffsetChanged)
            }
        }
        .coordinateSpace(name: "GithubReposScrollViewOrigin")
    }
    
    private func onOffsetChanged(_ offset: Offset) {
        if let _onReachEnd, !isLodaingMore, offset.maxOffset > 0, offset.offset > offset.maxOffset - 200 {
            isLodaingMore = true
            Task { @MainActor in
                defer { isLodaingMore = false }
                await _onReachEnd()
            }
        }
    }
    
    private struct OffsetPreferenceKey: PreferenceKey {
        static var defaultValue: Offset = .zero
        static func reduce(value: inout Offset, nextValue: () -> Offset) { }
    }
    
    private struct Offset: Equatable {
        let offset: CGFloat
        let maxOffset: CGFloat
        static var zero = Self.init(offset: 0, maxOffset: 0)
    }
}

struct ScalingButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

extension View {
    func infiniteScrollable(_ action: @escaping () async -> ()) -> some View {
        self
            .environment(\.infiniteScrollable, action)
    }
}

struct InfiniteScrollableEnvironmentKey: EnvironmentKey {
    static var defaultValue: (() async -> ())? = nil
}

extension EnvironmentValues {
    var infiniteScrollable: (() async -> ())? {
        get { self[InfiniteScrollableEnvironmentKey.self] }
        set { self[InfiniteScrollableEnvironmentKey.self] = newValue }
    }
}

#if DEBUG
struct GithubReposView_Previews: PreviewProvider {
    static var previews: some View {
        let repos: [GithubRepoModel] = [
            .init(id: 0,
                  name: "ver-useful-repo",
                  owner: .init(login: "John Smith", avatarUrl: "https://avatars.githubusercontent.com/u/9919?s=200&v=4"),
                  description: "让生产力加倍的 ChatGPT 快捷指令，按照领域和功能分区，可对提示词进行标签筛选、关键词搜索和一键复制。",
                  stargazersCount: 4195,
                  language: "Java",
                  forks: 12,
                  createdAt: "",
                  htmlUrl: ""),
            .init(id: 1,
                  name: "ver-useful-repo",
                  owner: .init(login: "John Smith", avatarUrl: ""),
                  description: "让生产力加倍的 ChatGPT 快捷指令，按照领域和功能分区，可对提示词进行标签筛选、关键词搜索和一键复制。",
                  stargazersCount: 4195,
                  language: "Java",
                  forks: 12,
                  createdAt: "",
                  htmlUrl: ""),
            .init(id: 2,
                  name: "HelpfulFramework",
                  owner: .init(login: "c00lhacker", avatarUrl: "https://avatars.githubusercontent.com/u/20487725?s=200&v=4"),
                  description: "Opensource IT Communities",
                  stargazersCount: 38500,
                  language: "Java",
                  forks: 12,
                  createdAt: "",
                  htmlUrl: ""),
            .init(id: 3,
                  name: "Pet_project",
                  owner: .init(login: "noob_user", avatarUrl: ""),
                  description: nil,
                  stargazersCount: 1,
                  language: "Java",
                  forks: 12,
                  createdAt: "",
                  htmlUrl: "")
        ]
        
        GithubReposView(repos: repos,
                        favouritedIDs: [0, 2])
    }
}

#endif
