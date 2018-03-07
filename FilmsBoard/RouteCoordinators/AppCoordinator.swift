//
//  AppCoordinator.swift
//  FilmsBoard
//
//  Created by Pablo on 07/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

@objc
class AppCoordinator: NSObject {

    private let tabsCoordinatorProvider: TabsCoordinatorProvider

    private var currentCoordinator: Coordinable!

    /**
     The current root coordinator of the app
     */
    var rootCoordinator: Coordinable {
        return currentCoordinator
    }

    @objc
    init(tabsCoordinatorProvider: TabsCoordinatorProvider) {
        self.tabsCoordinatorProvider = tabsCoordinatorProvider
        super.init()
        self.initFirstCoordinator()
    }
}

extension AppCoordinator {

    private func initFirstCoordinator() {
        currentCoordinator = tabsCoordinatorProvider.tabsCoordinator()
        currentCoordinator.start()
    }
}
