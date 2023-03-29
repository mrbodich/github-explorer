//
//  GithubRepoMapping.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 29.03.2023.
//

import Foundation
import CoreData

extension GithubRepoModel {
    init(from repo: GithubRepo) {
        id = UInt(repo.id)
        name = repo.name
        owner = .init(login: repo.ownerLogin,
                      avatarUrl: repo.ownerAvatarUrl)
        description = repo.descriptionText
        stargazersCount = UInt(repo.stargazersCount)
        language = repo.language
        forks = UInt(repo.forks)
        createdAt = repo.createdAt
        htmlUrl = repo.htmlUrl
    }
}

extension GithubRepo {
    convenience init(context: NSManagedObjectContext, from model: GithubRepoModel, isFavourited: Bool) {
        self.init(context: context)
        
        self.isFavourited = isFavourited
        id = Int64(model.id)
        name = model.name
        ownerLogin = model.owner.login
        ownerAvatarUrl = model.owner.avatarUrl
        descriptionText = model.description
        stargazersCount = Int64(model.stargazersCount)
        language = model.language
        forks = Int64(model.forks)
        createdAt = model.createdAt
        htmlUrl = model.htmlUrl
    }
}
