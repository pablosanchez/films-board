//
//  MediaItemsTabCoordinator.swift
//  FilmsBoard
//
//  Created by Pablo on 07/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

@objc
class MediaItemsTabCoordinator: NSObject {

    private let navigationController: UINavigationController
    private let mediaItemsViewModelProvider: MediaItemsViewModelProvider

    @objc
    init(mediaItemsViewModelProvider: MediaItemsViewModelProvider) {
        self.navigationController = UINavigationController()
        self.mediaItemsViewModelProvider = mediaItemsViewModelProvider
        super.init()
    }
}

extension MediaItemsTabCoordinator: Coordinable {

    /**
     The root view controller for this coordinator
     */
    var rootViewController: UIViewController {
        return navigationController
    }

    /**
     Initial configuration for the coordinator
     */
    func start() {
        self.initNavigationController()
    }
}

extension MediaItemsTabCoordinator {

    private func initNavigationController() {
        let viewModel = self.mediaItemsViewModelProvider.mediaItemsViewModel()
        let viewController = MediaItemsViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

@objc
protocol MediaItemsTabCoordinatorProvider: NSObjectProtocol {
    func mediaItemsTabCoordinator() -> MediaItemsTabCoordinator
}
