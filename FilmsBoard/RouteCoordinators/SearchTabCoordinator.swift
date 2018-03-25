//
//  SearchTabCoordinator.swift
//  FilmsBoard
//
//  Created by Pablo on 20/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

@objc
class SearchTabCoordinator: NSObject {

    private let navigationController: UINavigationController
    private let searchViewModelProvider: SearchViewModelProvider
    private let detailFilmViewModelProvider: DetailFilmViewModelProvider
    private let trailerCoordinatorProvider: TrailerCoordinatorProvider

    private var trailerCoordinator: TrailerCoordinator!

    @objc
    init(searchViewModelProvider: SearchViewModelProvider, detailFilmViewModelProvider: DetailFilmViewModelProvider,
         trailerCoordinatorProvider: TrailerCoordinatorProvider) {
        self.navigationController = UINavigationController()
        self.searchViewModelProvider = searchViewModelProvider
        self.detailFilmViewModelProvider = detailFilmViewModelProvider
        self.trailerCoordinatorProvider = trailerCoordinatorProvider
        super.init()
    }
}

extension SearchTabCoordinator: Coordinable {

    var rootViewController: UIViewController {
        return navigationController
    }

    func start() {
        self.initNavigationController()
    }
}

extension SearchTabCoordinator {

    private func initNavigationController() {
        let viewModel = self.searchViewModelProvider.searchViewModel()
        viewModel.routingDelegate = self

        let viewController = SearchViewController(viewModel: viewModel)
        viewController.addLeftBarButtonWithImage(UIImage(named: "ic-menu")!)  // Slide menu icon
        self.navigationController.pushViewController(viewController, animated: true)
        
        self.initTabBarItem()
    }

    private func initTabBarItem() {
        let tabTitle = "Buscar"
        self.navigationController.tabBarItem =
            UITabBarItem(title: tabTitle, image: UIImage(named: "tab-search"), tag: 1)
    }
}

extension SearchTabCoordinator: SearchViewModelRoutingDelegate {

    // MARK: SearchViewModelRoutingDelegate methods

    func searchViewModelDidTapCell(_ viewModel: SearchViewModel) {
        let viewModel = self.detailFilmViewModelProvider.detailFilmViewModel()
        viewModel.routingDelegate = self
        let viewController = DetailFilmController(viewModel: viewModel)

        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension SearchTabCoordinator: DetailFilmViewModelRoutingDelegate {

    // MARK: DetailFilmViewModelRoutingDelegate methods

    func detailFilmViewModelDidTapTrailerButton() {
        self.trailerCoordinator = self.trailerCoordinatorProvider.trailerCoordinator()
        self.trailerCoordinator.delegate = self
        self.trailerCoordinator.start()

        self.navigationController.present(trailerCoordinator.rootViewController, animated: true, completion: nil)
    }
}

extension SearchTabCoordinator: TrailerCoordinatorDelegate {

    // MARK: TrailerCoordinatorDelegate methods

    func trailerHasBeenClosed() {
        self.navigationController.dismiss(animated: true, completion: nil)
        self.trailerCoordinator = nil
    }
}

@objc
protocol SearchTabCoordinatorProvider: NSObjectProtocol {
    func searchTabCoordinator() -> SearchTabCoordinator
}
