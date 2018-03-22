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

    @objc
    init(searchViewModelProvider: SearchViewModelProvider) {
        self.navigationController = UINavigationController()
        self.searchViewModelProvider = searchViewModelProvider
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
        let viewController = SearchViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
        
        self.initTabBarItem()
    }

    private func initTabBarItem() {
        let tabTitle = "Buscar"
        self.navigationController.tabBarItem =
            UITabBarItem(title: tabTitle, image: UIImage(named: "tab-search"), tag: 1)
    }
}

@objc
protocol SearchTabCoordinatorProvider: NSObjectProtocol {
    func searchTabCoordinator() -> SearchTabCoordinator
}
