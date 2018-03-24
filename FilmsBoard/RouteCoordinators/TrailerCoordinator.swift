//
//  DetailMovieCoordinator.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 20/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

@objc class TrailerCoordinator: NSObject {
    
    private var navigationController: UIViewController
    private let viewModel: TrailerViewModel
    
    weak var delegate: TrailerCoordinatorDelegate?
    
    
    @objc
    init(viewModel: TrailerViewModel) {
        self.navigationController = UIViewController()
        self.viewModel = viewModel
        super.init()
        
        self.viewModel.delegate = self
        self.start()
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

extension TrailerCoordinator: TrailerViewModelDelegate {
    func trailerHasBeenClosed() {
        delegate?.trailerHasBeenClosed()
    }
}



protocol TrailerCoordinatorDelegate: class {
    func trailerHasBeenClosed()
}


@objc protocol TrailerCoordinatorProvider: NSObjectProtocol {
    func trailerCoordinator() -> TrailerCoordinator
}
