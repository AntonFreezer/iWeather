//
//  AppFlow.swift
//  iWeather
//
//  Created by Anton Kholodkov on 26.02.2024.
//

import UIKit

final class AppFlow: NavigationFlow {
    var navigationController = NavigationController()
}

extension AppFlow: Coordinator {
    /// Application entry point
    func start() {
        if UDService.isOnboardingCompleted() {
            process(route: .showMainView(.home(nil)))
        }
        
        // Onboarding
        // process(route: .showOnboarding)
    }
}

extension AppFlow: AppRouter {

    func exit() {
        // In this Router context - the only exit left is the main screen.
        // Logout - clean tokens - local cache - offline database if needed etc.
//        process(route: .showOnboarding)
    }

    func process(route: AppTransition) {
        let coordinator = route.coordinatorFor(router: self)

        coordinator.start()

        print(route.identifier)
    }

}

