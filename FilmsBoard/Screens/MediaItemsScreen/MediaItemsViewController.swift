//
//  ViewController.swift
//  FilmsBoard
//
//  Created by Pablo on 07/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

class MediaItemsViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    private let CELL_ID = "media-items-row"

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
        self.navigationItem.titleView = segmentedControl
        self.initTableView()

        viewModel.delegate = self
        viewModel.getMediaItemsByCategories(type: .movies)
    }
}

extension MediaItemsViewController {

    private func initTabBarItem() {
        let tabTitle = "Tendencias"
        self.tabBarItem = UITabBarItem(title: tabTitle, image: UIImage(named: "tab-featured"), tag: 0)
    }

    private func initTableView() {
        let rowNib = UINib(nibName: "MediaItemsRow", bundle: nil)
        self.tableView.register(rowNib, forCellReuseIdentifier: CELL_ID)

        self.tableView.dataSource = self
        self.tableView.rowHeight = 240
        self.tableView.separatorStyle = .none
    }
}

extension MediaItemsViewController: MediaItemsViewModelDelegate {

    func mediaItemsViewModelDidUpdateData(_ viewModel: MediaItemsViewModel) {
        self.tableView.reloadData()
    }
}

extension MediaItemsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! MediaItemsRow
        cell.viewModel = viewModel.tableCellViewModels[indexPath.row]

        return cell
    }
}
