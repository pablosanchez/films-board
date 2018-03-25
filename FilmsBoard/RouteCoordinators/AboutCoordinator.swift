//
//  AboutCoordinator.swift
//  FilmsBoard
//
//  Created by Pablo on 25/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

@objc
class AboutCoordinator: NSObject {

    private let navigationController: UINavigationController

    @objc
    override init() {
        self.navigationController = UINavigationController()
    }
}

extension AboutCoordinator: Coordinable {

    var rootViewController: UIViewController {
        return navigationController
    }

    func start() {
        self.initNavigationController()
    }
}

extension AboutCoordinator {

    private func initNavigationController() {
        let viewController = AboutViewController()
        viewController.addLeftBarButtonWithImage(UIImage(named: "ic-menu")!)  // Slide menu icon
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

@objc
protocol AboutCoordinatorProvider: NSObjectProtocol {
    func aboutCoordinator() -> AboutCoordinator
}
