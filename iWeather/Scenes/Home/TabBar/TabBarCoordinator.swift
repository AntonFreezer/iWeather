//
//  TabBarCoordinator.swift
//  iWeather
//
//  Created by Anton Kholodkov on 27.02.2024.
//

import UIKit

final class TabBarCoordinator<R: AppRouter>: NSObject, UITabBarControllerDelegate {
    
    //MARK: - Properties
    let appRouter: R
    var defaultTabItem: TabBarItem?

    private lazy var tabBarController: UITabBarController = {
        let tabBar = UITabBarController()
        
        tabBar.tabBar.isTranslucent = false
        tabBar.tabBar.barStyle = .black
        
        return tabBar
    }()

    private lazy var homeCoordinator: HomeCoordinator = {
        let homeRoute = HomeFlow(router: appRouter)
        let coordinator = HomeCoordinator(router: homeRoute)
        coordinator.start()
        return coordinator
    }()

    //MARK: - Lifecycle && Setup
    init(router: R, defaultTabItem: TabBarItem? = nil) {
        self.appRouter = router
        self.defaultTabItem = defaultTabItem
    }
    
    /// Creates a UITabBarItem from a given TabBarItem.
    /// - Parameter item: The TabBarItem to convert into a UITabBarItem.
    /// - Returns: A configured UITabBarItem.
    /// - Note: The `tag` property of the UITabBarItem is set to the index of the TabBarItem.
    private func tabBarItem(from item: TabBarItem) -> UITabBarItem {
        UITabBarItem(
            title: item.tabTitle,
            image: item.tabImage,
            tag: item.index
        )
    }

    /// Returns the appropriate view controller for a given TabBarItem.
    /// - Parameter transition: The TabBarItem to transition to.
    /// - Returns: A UIViewController corresponding to the TabBarItem.
    private func getTabController(for transition: TabBarItem) -> UIViewController {
        let navigationController: UINavigationController

        switch transition {
        case .home:
            navigationController = homeCoordinator.router.navigationController
        }

        navigationController.tabBarItem = tabBarItem(from: transition)
        return navigationController
    }

    /// Prepares and sets the main tab bar controller of the app.
    /// Sets the initial view controller if default tab is set
    /// - Parameter tabControllers: An array of view controllers to be set in the tab bar.
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: false)

        if appRouter.navigationController.viewControllers.first !== tabBarController {
            appRouter.navigationController.viewControllers.removeAll()
            appRouter.navigationController.viewControllers = [tabBarController]
            
            if let defaultTabItem {
                tabBarController.selectedViewController = tabControllers[defaultTabItem.index]
            }
        }
        
    }
}

//MARK: - Coordinator
extension TabBarCoordinator: Coordinator {
    func start() {
        
        let transitions: [TabBarItem] = [.home(nil)]

        let controllers: [UIViewController] = transitions.map { getTabController(for: $0) }
        prepareTabBarController(withTabControllers: controllers)
    }
}


