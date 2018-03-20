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
    private let mediaItemsCategoryViewModelProvider: MediaItemsCategoryViewModelProvider

    @objc
    init(mediaItemsViewModelProvider: MediaItemsViewModelProvider,
         mediaItemsCategoryViewModelProvider: MediaItemsCategoryViewModelProvider) {
        self.navigationController = UINavigationController()
        self.mediaItemsViewModelProvider = mediaItemsViewModelProvider
        self.mediaItemsCategoryViewModelProvider = mediaItemsCategoryViewModelProvider
        super.init()
    }
}

extension MediaItemsTabCoordinator: Coordinable {

    var rootViewController: UIViewController {
        return navigationController
    }

    func start() {
        self.initNavigationController()
    }
}

extension MediaItemsTabCoordinator {

    private func initNavigationController() {
        let viewModel = self.mediaItemsViewModelProvider.mediaItemsViewModel()
        viewModel.routingDelegate = self
        let viewController = MediaItemsViewController(viewModel: viewModel)

        self.navigationController.pushViewController(viewController, animated: true)
        self.initTabBarItem()
    }

    private func initTabBarItem() {
        let tabTitle = "Tendencias"
        self.navigationController.tabBarItem =
            UITabBarItem(title: tabTitle, image: UIImage(named: "tab-featured"), tag: 0)
    }
}

extension MediaItemsTabCoordinator: MediaItemsViewModelRoutingDelegate {
    
    func mediaItemsDidTapShowMoreButton(category: MovieTypes) {
        let viewModel = self.mediaItemsCategoryViewModelProvider.mediaItemsCategoryViewModel()
        viewModel.category = category
        let viewController = MediaItemsCategoryViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

@objc
protocol MediaItemsTabCoordinatorProvider: NSObjectProtocol {
    func mediaItemsTabCoordinator() -> MediaItemsTabCoordinator
}
