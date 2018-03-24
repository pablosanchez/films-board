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
    
    private var navigationController: UIViewController
    private let viewModel: TrailerViewModel
    
    weak var delegate: TrailerCoordinatorDelegate?

    @objc
    init(viewModel: TrailerViewModel) {
        self.navigationController = UIViewController()
        self.viewModel = viewModel
        super.init()
        self.viewModel.routingDelegate = self
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
        self.navigationController = TrailerViewController(viewModel: self.viewModel)
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

@objc protocol TrailerCoordinatorProvider: NSObjectProtocol {
    func trailerCoordinator() -> TrailerCoordinator
}
