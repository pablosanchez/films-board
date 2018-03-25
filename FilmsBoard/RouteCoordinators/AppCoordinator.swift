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
    private let listsCoordinatorProvider: ListsCoordinatorProvider
    private let aboutCoordinatorProvider: AboutCoordinatorProvider

    private var slideMenuController: SlideMenuController!
    private var slideMenu: SlideMenuViewController!

    private var tabsCoordinator: TabsCoordinator!
    private var mapCoordinator: MapCoordinator!
    private var listsCoordinator: ListsCoordinator!
    private var aboutCoordinator: AboutCoordinator!

    // The current root coordinator of the app
    var rootCoordinator: SlideMenuController {
        return slideMenuController
    }

    @objc
    init(tabsCoordinatorProvider: TabsCoordinatorProvider, mapCoordinatorProvider: MapCoordinatorProvider, listsCoordinatorProvider: ListsCoordinatorProvider, aboutCoordinatorProvider: AboutCoordinatorProvider) {
        self.tabsCoordinatorProvider = tabsCoordinatorProvider
        self.mapCoordinatorProvider = mapCoordinatorProvider
        self.listsCoordinatorProvider = listsCoordinatorProvider
        self.aboutCoordinatorProvider = aboutCoordinatorProvider
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
        self.tabsCoordinator = tabsCoordinator
        self.slideMenuController = SlideMenuController(mainViewController: self.tabsCoordinator.rootViewController, leftMenuViewController: self.slideMenu)
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
        self.tabsCoordinator = tabsCoordinator
        self.changeSlideMenuRootViewController(self.tabsCoordinator.rootViewController)
    }

    func slideMenuViewControllerDidTapListsButton(_ viewController: SlideMenuViewController) {
        self.slideMenuController.closeLeft()
        
        let listsCoordinator = listsCoordinatorProvider.listsCoordinator()
        listsCoordinator.start()
        self.listsCoordinator = listsCoordinator
        self.changeSlideMenuRootViewController(self.listsCoordinator.rootViewController)
    }

    func slideMenuViewControllerDidTapCloseCinemasButton(_ viewController: SlideMenuViewController) {
        self.slideMenuController.closeLeft()

        let mapCoordinator = mapCoordinatorProvider.mapCoordinator()
        mapCoordinator.start()
        self.mapCoordinator = mapCoordinator
        self.changeSlideMenuRootViewController(self.mapCoordinator.rootViewController)
    }

    func slideMenuViewControllerDidTapLicenciesButton(_ viewController: SlideMenuViewController) {
        self.slideMenuController.closeLeft()

        let aboutCoordinator = aboutCoordinatorProvider.aboutCoordinator()
        aboutCoordinator.start()
        self.aboutCoordinator = aboutCoordinator
        self.changeSlideMenuRootViewController(self.aboutCoordinator.rootViewController)
    }
}
