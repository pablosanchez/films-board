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

    @objc
    init(listsViewModelProvider: ListsViewModelProvider, detailedListViewModelProvider: DetailedListViewModelProvider) {
        self.navigationController = UINavigationController()
        self.listsViewModelProvider = listsViewModelProvider
        self.detailedListViewModelProvider = detailedListViewModelProvider
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
        let viewController = DetailedListViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

@objc
protocol ListsCoordinatorProvider: NSObjectProtocol {
    func listsCoordinator() -> ListsCoordinator
}
