//
//  HomeFlow.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit

final class HomeFlow<R: AppRouter>: NavigationFlow {
    let router: R
    var navigationController = NavigationController()

    init(router: R) {
        self.router = router
    }
}

extension HomeFlow: Coordinator {
    func start() {
        process(route: .initialScreen)
    }
}

extension HomeFlow: HomeRouter {

    func exit() {
        router.exit()
    }

    func process(route: HomeTransition) {
        let coordinator = route.coordinatorFor(router: self)

        coordinator.start()

        print(route.identifier)
    }
    
}
