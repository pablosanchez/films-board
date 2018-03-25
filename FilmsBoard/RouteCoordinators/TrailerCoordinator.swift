//
//  DetailMovieCoordinator.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 20/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

@objc
class TrailerCoordinator: NSObject {
    
    private var navigationController: UINavigationController
    private let viewModelProvider: TrailerViewModelProvider
    
    weak var delegate: TrailerCoordinatorDelegate?

    @objc
    init(viewModelProvider: TrailerViewModelProvider) {
        self.navigationController = UINavigationController()
        self.viewModelProvider = viewModelProvider
        super.init()
    }
}

extension TrailerCoordinator: Coordinable {

    var rootViewController: UIViewController {
        return navigationController
    }
    
    func start() {
        self.initNavigationController()
    }
}

extension TrailerCoordinator {
    
    private func initNavigationController() {
        let viewModel = self.viewModelProvider.trailerViewModel()
        viewModel.routingDelegate = self
        let viewController = TrailerViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension TrailerCoordinator: TrailerViewModelRoutingDelegate {

    // MARK: TrailerViewModelRoutingDelegate methods

    func trailerViewModelDidTapCloseButton(_ viewModel: TrailerViewModel) {
        delegate?.trailerHasBeenClosed()
    }
}

protocol TrailerCoordinatorDelegate: class {
    func trailerHasBeenClosed()
}

@objc
protocol TrailerCoordinatorProvider: NSObjectProtocol {
    func trailerCoordinator() -> TrailerCoordinator
}
