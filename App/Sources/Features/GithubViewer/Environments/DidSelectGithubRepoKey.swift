//
//  DidSelectGithubRepoKey.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 29.03.2023.
//

import Foundation
import SwiftUI

extension View {
    func didSelectGithubRepo(_ action: @escaping (_ repoModel: GithubRepoModel) -> ()) -> some View {
        self
            .environment(\.didSelectGithubRepo, action)
    }
}

struct DidSelectGithubRepoKey: EnvironmentKey {
    static var defaultValue: ((GithubRepoModel) -> ())? = nil
}

extension EnvironmentValues {
    var didSelectGithubRepo: ((GithubRepoModel) -> ())? {
        get { self[DidSelectGithubRepoKey.self] }
        set { self[DidSelectGithubRepoKey.self] = newValue }
    }
}
