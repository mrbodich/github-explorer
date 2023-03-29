//
//  GithubRepoDetailsView.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 28.03.2023.
//

import SwiftUI

struct GithubRepoDetailsView: View {
    @ObservedObject var viewModel: GithubRepoDetailsVM
    
    var body: some View {
        let repo = viewModel.model
        VStack(spacing: 0) {
            Color.gray
                .frame(width: 40, height: 4)
                .clipShape(Capsule(style: .continuous))
                .padding(.top, 4)
                .padding(.bottom, 25)
            
            ScrollView {
                VStack(spacing: 10) {
                    HStack(spacing: 0) {
                        Color.clear
                        CachingRemoteImage(urlStr: repo.owner.avatarUrl,
                                           placeholder: .color(.clear),
                                           contentMode: .fill)
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(alignment: .bottomTrailing) {
                            favouriteButton
                                .offset(x: 15, y: 5)
                        }
                        Color.clear
                    }
                    .padding(.bottom, 15)
                    
                    VStack(spacing: 0) {
                        Text(repo.owner.login)
                            .font(.largeTitle)
                            .lineLimit(1)
                        Text(repo.name)
                            .font(.title2)
                            .lineLimit(1)
                        HStack(spacing: 4) {
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                            Text("\(repo.stargazersCount)")
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                        }
                        .font(.body.weight(.regular))
                        .lineLimit(1)
                        .padding(.bottom, 20)
                        
                        if let description = repo.description {
                            Text(description)
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer(minLength: 30)
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Language: \(repo.language ?? "Unknown")")
                            Text("Forks: \(repo.forks)")
                            if let dateString = dateString(from: repo.createdAt) {
                                Text("Created at \(dateString)")
                            }
                        }
                        .font(.headline)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var favouriteButton: some View {
        Button {
            viewModel.toggleFavourite()
        } label: {
            Image(systemName: "star.circle")
                .font(.system(size: 40))
                .foregroundColor(viewModel.isFavourited ? .blue : .gray)
                .shadow(color: viewModel.isFavourited ? .white : .clear, radius: 20)
        }
    }
    
    private func dateString(from rawDateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        guard let date = dateFormatter.date(from: rawDateString) else { return nil }
        return formatter.string(from: date)
    }
}

#if DEBUG
struct GithubRepoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GithubRepoDetailsView(
            viewModel: MockGithubRepoDetailsVM(
                model: .init(id: 0,
                             name: "ver-useful-repo",
                             owner: .init(login: "John Smith", avatarUrl: "https://avatars.githubusercontent.com/u/9919?s=200&v=4"),
                             description: "让生产力加倍的 ChatGPT 快捷指令，按照领域和功能分区，可对提示词进行标签筛选、关键词搜索和一键复制。",
                             stargazersCount: 4195,
                             language: "Java",
                             forks: 12,
                             createdAt: "2023-03-04T05:21:09Z",
                             htmlUrl: "")
            )
        )
    }
}
#endif
