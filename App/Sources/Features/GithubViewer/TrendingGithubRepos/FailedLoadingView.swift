//
//  FailedLoadingView.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 29.03.2023.
//

import SwiftUI

struct FailedLoadingView: View {
    let action: () -> ()
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Server is not reachable.\nCheck your internet connection.")
                .multilineTextAlignment(.center)
            Button(action: action) {
                Text("Explore Favourite Repos")
                    .font(.title2.weight(.bold))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct FailedLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        FailedLoadingView { }
    }
}
