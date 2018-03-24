//
//  ListsCoordinator.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 24/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit



@objc class ListsCoordinator: NSObject {
    
    private let navigationController: UINavigationController
    private let listsViewModelProvider: ListsViewModelProvider

    
    
    @objc init(listsViewModelProvider: ListsViewModelProvider)
    {
        self.navigationController = UINavigationController()
        self.listsViewModelProvider = listsViewModelProvider
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
        let viewController = ListsViewController(viewModel: self.listsViewModelProvider.listsViewModel())
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
}




@objc protocol ListsCoordinatorProvider: NSObjectProtocol {
    func listsCoordinator() -> ListsCoordinator
}
