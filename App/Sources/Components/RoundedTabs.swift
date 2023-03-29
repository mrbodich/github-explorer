//
//  RoundedTabs.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import SwiftUI

protocol TitledTab: CaseIterable, Hashable {
    var title: String { get }
}

struct RoundedTabs<TabType: TitledTab>: View {
    @Binding private var selectedTab: TabType?
    private let tabs: [TabType]
    
    init(selectedTab: Binding<TabType?>, tabs: [TabType]? = nil) {
        _selectedTab = selectedTab
        self.tabs = tabs ?? Array(TabType.allCases)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                tabButton(tabs[index])
                    
                    .id(tabs[index])
                if index < tabs.count - 1 {
                    Color.clear.frame(width: nil, height: 1)
                        .layoutPriority(-2)
                }
            }
        }
    }
    
    @ViewBuilder
    private func tabButton(_ tab: TabType) -> some View {
        let isSelected = selectedTab == tab
        Button(action: {
            if selectedTab != tab {
                selectedTab = tab
            }
        }) {
            Text(tab.title)
                .foregroundColor(isSelected ? .white : .black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.horizontal, 15)
                .frame(height: 30)
            .background(isSelected ? .blue : .clear)
            .clipShape(Capsule())
            .overlay {
                Capsule().strokeBorder(.blue, lineWidth: !isSelected ? 1.3 : 0)
            }
            .contentShape(Rectangle())
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}

#if DEBUG
struct RoundedTabs_PreviewsWrapper: View {
    @State var selectedTab: PreviewTab? = .First
    
    var body: some View {
        VStack(spacing: 10) {
            RoundedTabs(selectedTab: $selectedTab)
            RoundedTabs(selectedTab: $selectedTab, tabs: [.Second, .Third, .First])
        }
        .padding(.horizontal, 20)
    }
    
    enum PreviewTab: String, TitledTab {
        case First, Second, Third
        
        var title: String { rawValue }
    }
}

struct RoundedTabs_Previews: PreviewProvider {
    static var previews: some View {
        RoundedTabs_PreviewsWrapper()
    }
}
#endif
