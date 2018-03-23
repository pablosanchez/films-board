//
//  AppCoordinator.swift
//  FilmsBoard
//
//  Created by Pablo on 07/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

@objc
class AppCoordinator: NSObject {

    private let tabsCoordinatorProvider: TabsCoordinatorProvider
    private let mapCoordinatorProvider: MapCoordinatorProvider

    private var slideMenuController: SlideMenuController!
    private var slideMenu: SlideMenuViewController!

    // The current root coordinator of the app
    var rootCoordinator: SlideMenuController {
        return slideMenuController
    }

    @objc
    init(tabsCoordinatorProvider: TabsCoordinatorProvider, mapCoordinatorProvider: MapCoordinatorProvider) {
        self.tabsCoordinatorProvider = tabsCoordinatorProvider
        self.mapCoordinatorProvider = mapCoordinatorProvider
        super.init()
        self.initSlideMenu()
    }
}

extension AppCoordinator {

    private func initSlideMenu() {
        self.slideMenu = SlideMenuViewController()
        self.slideMenu.delegate = self

        let tabsCoordinator = tabsCoordinatorProvider.tabsCoordinator()
        tabsCoordinator.start()
        self.slideMenuController = SlideMenuController(mainViewController: tabsCoordinator.rootViewController, leftMenuViewController: self.slideMenu)
    }

    private func changeSlideMenuRootViewController(_ viewController: UIViewController) {
        self.slideMenuController.mainViewController = viewController
    }
}

extension AppCoordinator: SlideMenuViewControllerDelegate {

    // MARK: SlideMenuViewControllerDelegate methods

    func slideMenuViewControllerDidTapHomeButton(_ viewController: SlideMenuViewController) {
        self.slideMenuController.closeLeft()

        let tabsCoordinator = tabsCoordinatorProvider.tabsCoordinator()
        tabsCoordinator.start()
        self.changeSlideMenuRootViewController(tabsCoordinator.rootViewController)
    }

    func slideMenuViewControllerDidTapListsButton(_ viewController: SlideMenuViewController) {
        self.slideMenuController.closeLeft()
    }

    func slideMenuViewControllerDidTapCloseCinemasButton(_ viewController: SlideMenuViewController) {
        self.slideMenuController.closeLeft()

        let mapCoordinator = mapCoordinatorProvider.mapCoordinator()
        mapCoordinator.start()
        self.changeSlideMenuRootViewController(mapCoordinator.rootViewController)
    }
}
