//
//  ListsCoordinator.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 24/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

@objc
class ListsCoordinator: NSObject {
    
    private let navigationController: UINavigationController
    private let listsViewModelProvider: ListsViewModelProvider
    private let detailedListViewModelProvider: DetailedListViewModelProvider
    private let detailFilmViewModelProvider: DetailFilmViewModelProvider
    private let trailerCoordinatorProvider: TrailerCoordinatorProvider

    private var trailerCoordinator: TrailerCoordinator!

    @objc
    init(listsViewModelProvider: ListsViewModelProvider, detailedListViewModelProvider: DetailedListViewModelProvider, detailFilmViewModelProvider: DetailFilmViewModelProvider, trailerCoordinatorProvider: TrailerCoordinatorProvider) {
        self.navigationController = UINavigationController()
        self.listsViewModelProvider = listsViewModelProvider
        self.detailedListViewModelProvider = detailedListViewModelProvider
        self.detailFilmViewModelProvider = detailFilmViewModelProvider
        self.trailerCoordinatorProvider = trailerCoordinatorProvider
        super.init()
    }
}

extension ListsCoordinator: Coordinable {

    var rootViewController: UIViewController {
        return navigationController
    }
    
    func start() {
        self.initNavigationController()
    }
}

extension ListsCoordinator {
    
    private func initNavigationController() {
        let viewModel = self.listsViewModelProvider.listsViewModel()
        let viewController = ListsViewController(viewModel: viewModel)
        viewController.addLeftBarButtonWithImage(UIImage(named: "ic-menu")!)  // Slide menu icon
        viewController.delegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension ListsCoordinator: ListsViewControllerDelegate {

    // MARK: ListsViewControllerDelegate methods

    func cellLitsTapped(listName: String) {
        let viewModel = self.detailedListViewModelProvider.detailedListViewModel()
        viewModel.setListName(name: listName)
        viewModel.routingDelegate = self
        let viewController = DetailedListViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension ListsCoordinator: DetailedListViewModelRoutingDelegate {

    // MARK: SearchViewModelRoutingDelegate methods

    func detailedListViewModelDidTapCell(_ viewModel: DetailedListViewModel) {
        let viewModel = self.detailFilmViewModelProvider.detailFilmViewModel()
        viewModel.routingDelegate = self
        let viewController = DetailFilmController(viewModel: viewModel)

        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension ListsCoordinator: DetailFilmViewModelRoutingDelegate {

    // MARK: DetailFilmViewModelRoutingDelegate methods

    func detailFilmViewModelDidTapTrailerButton() {
        self.trailerCoordinator = self.trailerCoordinatorProvider.trailerCoordinator()
        self.trailerCoordinator.delegate = self
        self.trailerCoordinator.start()

        self.navigationController.present(trailerCoordinator.rootViewController, animated: true, completion: nil)
    }
}

extension ListsCoordinator: TrailerCoordinatorDelegate {

    // MARK: TrailerCoordinatorDelegate methods

    func trailerHasBeenClosed() {
        self.navigationController.dismiss(animated: true, completion: nil)
        self.trailerCoordinator = nil
    }
}

@objc
protocol ListsCoordinatorProvider: NSObjectProtocol {
    func listsCoordinator() -> ListsCoordinator
}
