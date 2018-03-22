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

    private var slideMenuController: SlideMenuController!
    private var activeCoordinator: Coordinable!

    // The current root coordinator of the app
    var rootCoordinator: SlideMenuController {
        return slideMenuController
    }

    @objc
    init(tabsCoordinatorProvider: TabsCoordinatorProvider) {
        self.tabsCoordinatorProvider = tabsCoordinatorProvider
        super.init()
        self.initFirstCoordinator()
        self.initSlideMenu()
    }
}

extension AppCoordinator {

    private func initFirstCoordinator() {
        let tabsCoordinator = tabsCoordinatorProvider.tabsCoordinator()
        tabsCoordinator.start()

        self.activeCoordinator = tabsCoordinator
    }

    private func initSlideMenu() {
        let slideMenu = SlideMenuViewController()
        slideMenu.delegate = self
        self.slideMenuController = SlideMenuController(mainViewController: self.activeCoordinator.rootViewController, leftMenuViewController: slideMenu)
    }
}

extension AppCoordinator: SlideMenuViewControllerDelegate {

    // MARK: SlideMenuViewControllerDelegate methods

    func slideMenuViewControllerDidTapListsButton(_ viewController: SlideMenuViewController) {
        self.slideMenuController.closeLeft()
    }

    func slideMenuViewControllerDidTapCloseCinemasButton(_ viewController: SlideMenuViewController) {
        self.slideMenuController.closeLeft()
    }
}
