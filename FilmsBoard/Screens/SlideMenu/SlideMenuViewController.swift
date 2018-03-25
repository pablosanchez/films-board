//
//  SlideMenuViewController.swift
//  FilmsBoard
//
//  Created by Pablo on 21/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController {

    weak var delegate: SlideMenuViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func homeButtonTapped() {
        delegate?.slideMenuViewControllerDidTapHomeButton(self)
    }

    @IBAction func myListsButtonTapped() {
        delegate?.slideMenuViewControllerDidTapListsButton(self)
    }

    @IBAction func closeCinemasButtonTapped() {
        delegate?.slideMenuViewControllerDidTapCloseCinemasButton(self)
    }
    
    @IBAction func licensiesButtonTapped() {
        delegate?.slideMenuViewControllerDidTapLicenciesButton(self)
    }
}

protocol SlideMenuViewControllerDelegate: class {
    func slideMenuViewControllerDidTapHomeButton(_ viewController: SlideMenuViewController)
    func slideMenuViewControllerDidTapListsButton(_ viewController: SlideMenuViewController)
    func slideMenuViewControllerDidTapCloseCinemasButton(_ viewController: SlideMenuViewController)
    func slideMenuViewControllerDidTapLicenciesButton(_ viewController: SlideMenuViewController)
}
