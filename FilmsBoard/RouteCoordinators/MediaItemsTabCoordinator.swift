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
    private let trailerCoordinatorProvider: TrailerCoordinatorProvider
    private var trailerCoordinator: TrailerCoordinator?

    
    
    @objc
    init(viewModel: MediaItemsViewModel, detailFilmViewModelProvider: DetailFilmViewModelProvider, trailerCoordinatorProvider: TrailerCoordinatorProvider) {
        self.navigationController = UINavigationController()
        self.viewModel = viewModel
        self.detailFilmViewModelProvider = detailFilmViewModelProvider
        self.trailerCoordinatorProvider = trailerCoordinatorProvider
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
        viewModel.delegate = self
        
        let viewModel2 = ListsViewModel(database: SQLiteDatabase())
        let viewController = DetailFilmController(viewModel: viewModel)
        let viewController2 = ListsController(viewModel: viewModel2)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}


extension MediaItemsTabCoordinator: TrailerButtonTappedDelegate {
    func trailerButtonTapped() {
        let trailerCoordinator = self.trailerCoordinatorProvider.trailerCoordinator()
        self.trailerCoordinator = trailerCoordinator
        self.trailerCoordinator?.delegate = self
        
        self.navigationController.present(trailerCoordinator.rootViewController, animated: true, completion: nil)
    }
}


extension MediaItemsTabCoordinator: TrailerCoordinatorDelegate {
    func trailerHasBeenClosed() {
        self.navigationController.dismiss(animated: true, completion: nil)
        self.trailerCoordinator = nil
    }
}



@objc
protocol MediaItemsTabCoordinatorProvider: NSObjectProtocol {
    func mediaItemsTabCoordinator() -> MediaItemsTabCoordinator
}
