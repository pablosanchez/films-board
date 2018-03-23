//
//  MapCoordinator.swift
//  FilmsBoard
//
//  Created by Pablo on 22/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

@objc
class MapCoordinator: NSObject {

    private let navigationController: UINavigationController
    private let mapViewModelProvider: MapViewModelProvider

    @objc
    init(mapViewModelProvider: MapViewModelProvider) {
        self.navigationController = UINavigationController()
        self.mapViewModelProvider = mapViewModelProvider
        super.init()
    }
}

extension MapCoordinator: Coordinable {

    var rootViewController: UIViewController {
        return navigationController
    }

    func start() {
        self.initNavigationController()
    }
}

extension MapCoordinator {

    private func initNavigationController() {
        let viewModel = mapViewModelProvider.mapViewModel()
        let viewController = MapViewController(viewModel: viewModel)
        viewController.addLeftBarButtonWithImage(UIImage(named: "ic-menu")!)  // Slide menu icon

        self.navigationController.pushViewController(viewController, animated: true)
    }
}

@objc
protocol MapCoordinatorProvider: NSObjectProtocol {
    func mapCoordinator() -> MapCoordinator
}

