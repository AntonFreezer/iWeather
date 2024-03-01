//
//  SettingsCoordinator.swift
//  iWeather
//
//  Created by Anton Kholodkov on 29.02.2024.
//

import UIKit

final class SettingsCoordinator<R: Routable> {
    let router: R

    init(router: R) {
        self.router = router
    }

    private lazy var primaryViewController: UIViewController = {
        let viewController = SettingsViewController()
        return viewController
    }()
}

extension SettingsCoordinator: Coordinator {
    func start() {
        router.navigationController.setNavigationBarHidden(false, animated: true)
        router.navigationController.pushViewController(primaryViewController, animated: true)
    }
}
