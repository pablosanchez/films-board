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
    private let detailFilmViewModelProvider: DetailFilmViewModelProvider
    private let trailerCoordinatorProvider: TrailerCoordinatorProvider

    private var trailerCoordinator: TrailerCoordinator!

    @objc
    init(mediaItemsViewModelProvider: MediaItemsViewModelProvider,
         mediaItemsCategoryViewModelProvider: MediaItemsCategoryViewModelProvider,
         detailFilmViewModelProvider: DetailFilmViewModelProvider,
         trailerCoordinatorProvider: TrailerCoordinatorProvider) {
        self.navigationController = UINavigationController()
        self.mediaItemsViewModelProvider = mediaItemsViewModelProvider
        self.mediaItemsCategoryViewModelProvider = mediaItemsCategoryViewModelProvider
        self.detailFilmViewModelProvider = detailFilmViewModelProvider
        self.trailerCoordinatorProvider = trailerCoordinatorProvider
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
        viewModel.cellDelegate = self
        viewModel.routingDelegate = self

        let viewController = MediaItemsViewController(viewModel: viewModel)
        viewController.addLeftBarButtonWithImage(UIImage(named: "ic-menu")!)  // Slide menu icon
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

    func mediaItemsDidTapShowMoreButton(totalPages: Int?, type: MediaItemTypes, category: MediaItemCategories) {
        let viewModel = self.mediaItemsCategoryViewModelProvider.mediaItemsCategoryViewModel()
        viewModel.totalPages = totalPages
        viewModel.type = type
        viewModel.category = category
        viewModel.routingDelegate = self

        let viewController = MediaItemsCategoryViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension MediaItemsTabCoordinator: MediaItemsCellSelectedDelegate {

    // MARK: MediaItemsCellSelectedDelegate methods

    func cellTapped(mediaItem: MediaItem) {
        let viewModel = self.detailFilmViewModelProvider.detailFilmViewModel()
        viewModel.routingDelegate = self
        let viewController = DetailFilmController(viewModel: viewModel)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension MediaItemsTabCoordinator: MediaItemsCategoryViewModelRoutingDelegate {

    // MARK: MediaItemsCategoryViewModelRoutingDelegate methods

    func mediaItemsCategoryViewModelDidTapCell(_ viewModel: MediaItemsCategoryViewModel) {
        let viewModel = self.detailFilmViewModelProvider.detailFilmViewModel()
        viewModel.routingDelegate = self
        let viewController = DetailFilmController(viewModel: viewModel)

        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension MediaItemsTabCoordinator: DetailFilmViewModelRoutingDelegate {

    // MARK: DetailFilmViewModelRoutingDelegate methods

    func detailFilmViewModelDidTapTrailerButton() {
        self.trailerCoordinator = self.trailerCoordinatorProvider.trailerCoordinator()
        self.trailerCoordinator.delegate = self
        self.trailerCoordinator.start()
        
        self.navigationController.present(trailerCoordinator.rootViewController, animated: true, completion: nil)
    }
}

extension MediaItemsTabCoordinator: TrailerCoordinatorDelegate {

    // MARK: TrailerCoordinatorDelegate methods
    
    func trailerHasBeenClosed() {
        self.navigationController.dismiss(animated: true, completion: nil)
        self.trailerCoordinator = nil
    }
}

@objc
protocol MediaItemsTabCoordinatorProvider: NSObjectProtocol {
    func mediaItemsTabCoordinator() -> MediaItemsTabCoordinator
}
