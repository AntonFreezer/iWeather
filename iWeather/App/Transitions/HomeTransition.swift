//
//  HomeTransition.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import Foundation

enum HomeTransition {
    case initialScreen
    //    case profileScreen
    //    case settingsScreen
    
    var identifier: String { "\(self)" }
    
    func coordinatorFor<R: HomeRouter>(router: R) -> Coordinator {
        switch self {
        case .initialScreen:
            return HomeCoordinator(router: router)
            //        case .profileScreen:
            //            return
            //        case .settingsScreen:
            //            return
        }
    }
}
