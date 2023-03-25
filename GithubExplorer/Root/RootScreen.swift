//
//  RootScreen.swift
//  Github Explorer
//
//  Created by Bogdan Chornobryvets on 25.03.2023.
//

import SwiftUI

struct RootScreen: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen()
    }
}
