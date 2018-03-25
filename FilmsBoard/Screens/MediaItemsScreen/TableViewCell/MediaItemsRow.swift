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
        self.collectionView.setCollectionViewLayout(layout, animated: false)

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
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
        
        cell.layer.borderWidth = CGFloat(1.0)
        cell.layer.borderColor = UIColor(named: "Primary_Dark")?.cgColor
        
        return cell
    }
}

extension MediaItemsRow: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.selectedItem(index: indexPath.row)
    }
}

extension MediaItemsRow: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isIpad = traitCollection.horizontalSizeClass == .regular
            && traitCollection.verticalSizeClass == .regular
        return CGSize(width: isIpad ? 160 : 100, height: isIpad ? 280 : 180)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let isIpad = traitCollection.horizontalSizeClass == .regular
            && traitCollection.verticalSizeClass == .regular
        let inset: CGFloat = isIpad ? 20 : 10
        return UIEdgeInsets(top: inset, left: 10, bottom: inset, right: 10)
    }
}
