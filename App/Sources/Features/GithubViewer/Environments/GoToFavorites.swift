//
//  GoToFavorites.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 29.03.2023.
//

import Foundation
import SwiftUI

extension View {
    func goToFavoritesDidPress(_ action: @escaping () -> ()) -> some View {
        self
            .environment(\.goToFavoritesDidPress, action)
    }
}

struct GoToFavoritesDidPressKey: EnvironmentKey {
    static var defaultValue: (() -> ())? = nil
}

extension EnvironmentValues {
    var goToFavoritesDidPress: (() -> ())? {
        get { self[GoToFavoritesDidPressKey.self] }
        set { self[GoToFavoritesDidPressKey.self] = newValue }
    }
}
