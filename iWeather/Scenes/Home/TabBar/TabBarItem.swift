//
//  TabBarItem.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit

enum TabBarItem {
    case home(HomeTransition?)
    
    var tabTitle: String {
        switch self {
        case .home:
            return String(localized: "Picture of the day")
        }
    }
    
    var index: Int {
        switch self {
        case .home:
            return 0
        }
    }
    
    var tabImage: UIImage? {
        switch self {
        case .home:
            let configuration = UIImage.SymbolConfiguration(hierarchicalColor: .white)
            return UIImage(systemName: "house",
                           withConfiguration: configuration)
        }
    }
}
