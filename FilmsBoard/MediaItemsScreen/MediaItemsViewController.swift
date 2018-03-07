//
//  ViewController.swift
//  FilmsBoard
//
//  Created by Pablo on 07/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

class MediaItemsViewController: UIViewController {

    private let viewModel: MediaItemsViewModel

    init(viewModel: MediaItemsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initTabBarItem()
    }
}

extension MediaItemsViewController {

    private func initTabBarItem() {
        let tabTitle = "Tendencias"
        self.tabBarItem = UITabBarItem(title: tabTitle, image: UIImage(named: "tab-featured"), tag: 0)
    }
}
