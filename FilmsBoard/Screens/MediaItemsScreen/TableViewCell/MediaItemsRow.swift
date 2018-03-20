//
//  MediaItemsRow.swift
//  FilmsBoard
//
//  Created by Pablo on 08/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

class MediaItemsRow: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private let CELL_ID = "media-item-cell"

    var viewModel: MediaItemsRowViewModel? {
        didSet {
            self.cellTitle.text = viewModel?.title
            self.collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initCollectionView()
    }
}

extension MediaItemsRow {

    private func initCollectionView() {
        let cellNib = UINib(nibName: "MediaItemCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: CELL_ID)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.setCollectionViewLayout(layout, animated: false)

        self.collectionView.dataSource = self
    }

    @IBAction func showMoreTapped() {
        viewModel?.handleShowMoreButtonTap()
    }
}

extension MediaItemsRow: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.viewModels.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! MediaItemCell
        cell.viewModel = viewModel?.viewModels[indexPath.row]
        return cell
    }
}
