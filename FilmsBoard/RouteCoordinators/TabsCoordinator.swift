//
//  TabsCoordinator.swift
//  FilmsBoard
//
//  Created by Pablo on 07/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

@objc
class TabsCoordinator: NSObject {

    private let tabBarController: UITabBarController
    private let mediaItemsTabCoordinatorProvider: MediaItemsTabCoordinatorProvider
    private let searchTabCoordinatorProvider: SearchTabCoordinatorProvider

    private var firstTabCoordinator: Coordinable!
    private var secondTabCoordinator: Coordinable!

    @objc
    init(mediaItemsTabCoordinatorProvider: MediaItemsTabCoordinatorProvider,
         searchTabCoordinatorProvider: SearchTabCoordinatorProvider) {
        self.tabBarController = UITabBarController()
        self.mediaItemsTabCoordinatorProvider = mediaItemsTabCoordinatorProvider
        self.searchTabCoordinatorProvider = searchTabCoordinatorProvider
        super.init()
    }
}

extension TabsCoordinator: Coordinable {

    // The root view controller for this coordinator
    var rootViewController: UIViewController {
        return tabBarController
    }

    // Initial configuration for the coordinator
    func start() {
        self.initTabBarController()
    }
}

extension TabsCoordinator {

    private func initTabBarController() {
        self.initFirstTab()
        self.initSecondTab()
    }

    private func initFirstTab() {
        let tabCoordinator = mediaItemsTabCoordinatorProvider.mediaItemsTabCoordinator()
        tabCoordinator.start()
        self.tabBarController.viewControllers = [tabCoordinator.rootViewController]

        self.firstTabCoordinator = tabCoordinator
    }

    private func initSecondTab() {
        let tabCoordinator = searchTabCoordinatorProvider.searchTabCoordinator()
        tabCoordinator.start()
        self.tabBarController.viewControllers?.append(tabCoordinator.rootViewController)

        self.secondTabCoordinator = tabCoordinator
    }
}

@objc
protocol TabsCoordinatorProvider: NSObjectProtocol {
    func tabsCoordinator() -> TabsCoordinator
}
