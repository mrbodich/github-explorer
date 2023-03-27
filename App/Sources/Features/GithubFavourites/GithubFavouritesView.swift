//
//  GithubFavouritesView.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 27.03.2023.
//

import SwiftUI

struct GithubFavouritesView: View {
    @ObservedObject var viewModel: GithubFavouritesVM
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct GithubFavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        GithubFavouritesView(
            viewModel: .init()
        )
    }
}
