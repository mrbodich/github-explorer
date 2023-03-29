//
//  GithubRepo+CoreDataProperties.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 29.03.2023.
//
//

import Foundation
import CoreData


extension GithubRepo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GithubRepo> {
        return NSFetchRequest<GithubRepo>(entityName: "GithubRepo")
    }

    @NSManaged public var createdAt: String
    @NSManaged public var descriptionText: String?
    @NSManaged public var forks: Int64
    @NSManaged public var htmlUrl: String
    @NSManaged public var id: Int64
    @NSManaged public var isFavourited: Bool
    @NSManaged public var language: String?
    @NSManaged public var name: String
    @NSManaged public var ownerAvatarUrl: String
    @NSManaged public var ownerLogin: String
    @NSManaged public var stargazersCount: Int64

}

extension GithubRepo : Identifiable {

}
