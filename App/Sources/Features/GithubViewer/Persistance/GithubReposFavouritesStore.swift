//
//  GithubReposFavouritesStore.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 28.03.2023.
//

import Foundation
import CoreData
import Combine

class GithubReposFavouritesStore: ObservableObject {
    @Published var favouritedGithubRepos: [GithubRepoModel] = []
    @Published var favouritedGithubRepoIDs: Set<UInt> = []
    private let publisher: FetchedResultsPublisher<GithubRepo>
    private let viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    private var bucket: Set<AnyCancellable> = []
    
    init() {
        let fetchRequest = GithubRepo.fetchRequest()
        let sort = NSSortDescriptor(key: "stargazersCount", ascending: false)
        let predicate = NSPredicate(format: "isFavourited == true")
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        
        publisher = FetchedResultsPublisher(request: fetchRequest, context: PersistenceController.shared.container.viewContext)
        
        subscribe()
    }
    
    func add(githubRepoModel model: GithubRepoModel) {
        let _ = GithubRepo(context: viewContext, from: model, isFavourited: true)
        PersistenceController.shared.saveViewContext()
    }
    
    func remove(repoWithId id: UInt) {
        let fetchRequest = GithubRepo.fetchRequest()
        let idPredicate = NSPredicate(
            format: "id == %d", id
        )
        fetchRequest.predicate = idPredicate
        let repos = try? viewContext.fetch(fetchRequest)
        repos?.forEach { viewContext.delete($0) }
        PersistenceController.shared.saveViewContext()
    }
    
    private func subscribe() {
        publisher
            .replaceError(with: [])
            .map{ $0.map(GithubRepoModel.init) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repos in
                self?.favouritedGithubRepos = repos
                self?.favouritedGithubRepoIDs = Set(repos.map(\.id))
            }
            .store(in: &bucket)
    }
}
