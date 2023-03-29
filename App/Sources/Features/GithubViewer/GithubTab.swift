//
//  GithubTab.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 26.03.2023.
//

import Foundation

enum GithubTab: TitledTab {
    case day, week, month
    
    var title: String {
        switch self {
        case .day:      return "Last Day"
        case .week:     return "Last Week"
        case .month:    return "Last Month"
        }
    }
}
