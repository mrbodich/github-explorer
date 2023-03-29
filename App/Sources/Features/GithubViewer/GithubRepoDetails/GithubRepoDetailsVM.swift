//
//  GithubRepoDetailsVM.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 28.03.2023.
//

import Foundation
import Combine

protocol GithubRepoDetailsDelegate: AnyObject {
    func repoDidFavourited(_ repo: GithubRepoModel)
    func repoDidRemoveFromFavourites(withId id: UInt)
}

class GithubRepoDetailsVM: ObservableObject, Identifiable {
    let id: UInt
    let model: GithubRepoModel
    weak var favouritesStore: GithubReposFavouritesStore?
    weak var delegate: GithubRepoDetailsDelegate?
    
    @Published var isFavourited: Bool = false
    
    init(model: GithubRepoModel, favouritesStore: GithubReposFavouritesStore? = nil) {
        id = model.id
        self.model = model
        self.favouritesStore = favouritesStore
        
        subscribe()
    }
    
    func toggleFavourite() {
        switch isFavourited {
        case true: delegate?.repoDidRemoveFromFavourites(withId: id)
        case false: delegate?.repoDidFavourited(model)
        }
    }
    
    private func subscribe() {
        guard let favouritesStore else { return }
        favouritesStore.$favouritedGithubRepoIDs
            .removeDuplicates()
            .map { [weak self] in
                guard let id = self?.id else { return false }
                return $0.contains(id)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isFavourited)
    }
    
}

#if DEBUG
class MockGithubRepoDetailsVM: GithubRepoDetailsVM {
    override func toggleFavourite() {
        isFavourited.toggle()
    }
}
#endif
