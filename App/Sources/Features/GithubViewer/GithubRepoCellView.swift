//
//  GithubRepoCellView.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import SwiftUI

struct GithubRepoCellView: View {
    let model: GithubRepoModel
    let isFavourited: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    CachingRemoteImage(urlStr: model.owner.avatarUrl,
                                       placeholder: .image(UIImage(named: "noImage")!),
                                       contentMode: .fill)
                }
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 0) {
                Text(model.owner.login.uppercased())
                    .font(.caption.weight(.light))
                HStack(spacing: 0) {
                    Text(model.name)
                        .font(.footnote.bold())
                        .padding(.trailing, 6)
                    Image(systemName: "star")
                        .font(.footnote.weight(.regular))
                        .foregroundColor(.yellow)
                    Text("\(model.stargazersCount)")
                        .font(.caption.weight(.light))
                }
                .lineLimit(1)
                Group {
                    switch model.description {
                    case let .some(description):
                        Text(description)
                    case .none:
                        Text("Repo does not contain description")
                            .opacity(0.38)
                    }
                }
                .font(.caption.italic().weight(.light))
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .frame(maxHeight: .infinity, alignment: .top)
            }
            Spacer(minLength: 0)
            if isFavourited {
                Image(systemName: "star.circle")
                    .font(.title2.weight(.light))
                    .foregroundColor(.blue)
                    .frame(width: 55, height: 55)
            }
        }
        .frame(height: 55)
        .padding(.all, 3)
        .background(Color.white)
        .clipShape(Capsule(style: .circular))
        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
        .compositingGroup()
    }
}

struct GithubRepoCellView_Previews: PreviewProvider {
    static var previews: some View {
        let repos: [GithubRepoModel] = [
            .init(id: 0,
                  name: "ver-useful-repo",
                  owner: .init(login: "John Smith", avatarUrl: "https://avatars.githubusercontent.com/u/9919?s=200&v=4"),
                  description: "让生产力加倍的 ChatGPT 快捷指令，按照领域和功能分区，可对提示词进行标签筛选、关键词搜索和一键复制。",
                  stargazersCount: 4195),
            .init(id: 1,
                  name: "ver-useful-repo",
                  owner: .init(login: "John Smith", avatarUrl: ""),
                  description: "让生产力加倍的 ChatGPT 快捷指令，按照领域和功能分区，可对提示词进行标签筛选、关键词搜索和一键复制。",
                  stargazersCount: 4195),
            .init(id: 2,
                  name: "HelpfulFramework",
                  owner: .init(login: "c00lhacker", avatarUrl: "https://avatars.githubusercontent.com/u/20487725?s=200&v=4"),
                  description: "Opensource IT Communities",
                  stargazersCount: 38500),
            .init(id: 3,
                  name: "Pet_project",
                  owner: .init(login: "noob_user", avatarUrl: ""),
                  description: nil,
                  stargazersCount: 1)
        ]
        
        let favouritedIDs: Set<UInt> = [1, 3]
        
        VStack(spacing: 10) {
            ForEach(repos) { repo in
                GithubRepoCellView(model: repo,
                                   isFavourited: favouritedIDs.contains(repo.id))
            }
        }
        .padding(.horizontal, 10)
    }
}
