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
    private let viewModel: MediaItemsViewModel
    private let detailFilmViewModelProvider: DetailFilmViewModelProvider

    @objc
    init(viewModel: MediaItemsViewModel, detailFilmViewModelProvider: DetailFilmViewModelProvider) {
        self.navigationController = UINavigationController()
        self.viewModel = viewModel
        self.detailFilmViewModelProvider = detailFilmViewModelProvider
        super.init()
        
        self.viewModel.cellDelegate = self
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
        let viewController = MediaItemsViewController(viewModel: self.viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}


extension MediaItemsTabCoordinator: MediaItemsCellSelectedDelegate {
    func cellTapped(mediaItem: MediaItem, isUpcoming: Bool) {
        let viewModel = self.detailFilmViewModelProvider.detailFilmViewModel()
        let viewController = DetailFilmController(viewModel: viewModel)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}



@objc
protocol MediaItemsTabCoordinatorProvider: NSObjectProtocol {
    func mediaItemsTabCoordinator() -> MediaItemsTabCoordinator
}
