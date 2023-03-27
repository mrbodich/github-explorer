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
    
    init(repos: [GithubRepoModel], favouritedIDs: Set<UInt>) {
        self.repos = repos
        self.favouritedIDs = favouritedIDs
    }
    
    private var _onReachEnd: (() -> ())? = nil
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(repos) { repo in
                    Button {
                        
                    } label: {
                        GithubRepoCellView(model: repo,
                                           isFavourited: favouritedIDs.contains(repo.id))
                    }
                    .buttonStyle(ScalingButtonStyle())
                                
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .background {
                GeometryReader { proxy in
                    Color.clear.preference(key: OffsetPreferenceKey.self,
                                           value: .init(offset: proxy.frame(in: .named("GithubReposScrollViewOrigin")).origin,
                                                        parentRect: proxy.size))

                }
            }
        }
        .coordinateSpace(name: "GithubReposScrollViewOrigin")
        .onPreferenceChange(OffsetPreferenceKey.self,
                            perform: onOffsetChanged)
    }
    
    func onReachEnd(_ perform: @escaping (() -> ())) -> Self {
        var mutableSelf = self
        mutableSelf._onReachEnd = perform
        return mutableSelf
    }
    
    private func onOffsetChanged(_ offset: Offset) {
        print(offset)
    }
    
    private struct OffsetPreferenceKey: PreferenceKey {
        static var defaultValue: Offset = .zero
        static func reduce(value: inout Offset, nextValue: () -> Offset) { }
    }
    
    private struct Offset: Equatable {
        let offset: CGPoint
        let parentRect: CGSize
        static var zero = Self.init(offset: .zero, parentRect: .zero)
    }
}

struct ScalingButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
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
                  createdAt: ""),
            .init(id: 1,
                  name: "ver-useful-repo",
                  owner: .init(login: "John Smith", avatarUrl: ""),
                  description: "让生产力加倍的 ChatGPT 快捷指令，按照领域和功能分区，可对提示词进行标签筛选、关键词搜索和一键复制。",
                  stargazersCount: 4195,
                  createdAt: ""),
            .init(id: 2,
                  name: "HelpfulFramework",
                  owner: .init(login: "c00lhacker", avatarUrl: "https://avatars.githubusercontent.com/u/20487725?s=200&v=4"),
                  description: "Opensource IT Communities",
                  stargazersCount: 38500,
                  createdAt: ""),
            .init(id: 3,
                  name: "Pet_project",
                  owner: .init(login: "noob_user", avatarUrl: ""),
                  description: nil,
                  stargazersCount: 1,
                  createdAt: "")
        ]
        
        GithubReposView(repos: repos,
                        favouritedIDs: [0, 2])
    }
}

#endif
