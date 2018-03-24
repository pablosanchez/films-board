//
//  MediaItemsCategoryViewController.swift
//  FilmsBoard
//
//  Created by Pablo on 14/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import MBProgressHUD
import MaterialComponents



class MediaItemsCategoryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var progressIndicator: MBProgressHUD!

    private let CELL_ID = "media-item-cell"
    private let margin_vertical: CGFloat = 10  // Collection view margin
    private let margin_horizontal: CGFloat = 5
    
    
    private let viewModel: MediaItemsCategoryViewModel

    init(viewModel: MediaItemsCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.delegate = self
        self.title = viewModel.title
        self.initCollectionView()
    }
}

extension MediaItemsCategoryViewController {

    private func initCollectionView() {
        let cellNib = UINib(nibName: "MediaItemDetailedCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: CELL_ID)

        self.assignLayout()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

extension MediaItemsCategoryViewController: MediaItemsCategoryViewModelDelegate {

    // MARK: MediaItemsCategoryViewModelDelegate methods

    func mediaItemsCategoryViewModelDidUpdateData(_ viewModel: MediaItemsCategoryViewModel) {
        self.progressIndicator.hide(animated: true)
        self.collectionView.reloadData()
    }

    func mediaItemsCategoryViewModelDidFinishUpdatingData(_ viewModel: MediaItemsCategoryViewModel) {
        self.progressIndicator.hide(animated: true)
    }

    func mediaItemsCategoryViewModel(_ viewModel: MediaItemsCategoryViewModel, didGetError errorMessage: String) {
        SCLAlertViewBuilder()
            .setTitle("Aviso")
            .setSubtitle(errorMessage)
            .setCloseButtonTitle("Ok")
            .setCircleIconImage(UIImage(named: "ic-no-network"))
            .show()
    }
}

extension MediaItemsCategoryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! MediaItemDetailedCell
        cell.viewModel = viewModel.cellViewModels[indexPath.row]
        
        cell.layer.borderWidth = CGFloat(1.0)
        cell.layer.borderColor = UIColor(named: "Primary_Dark")?.cgColor
        
        
        
        if indexPath.row == (viewModel.cellViewModels.count - 1) {  // Infinite scroll
            self.progressIndicator = MBProgressHUDBuilder.makeProgressIndicator(view: self.view)
            viewModel.getNextMediaItemsPage()
        }

        return cell
    }
}

extension MediaItemsCategoryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemsPerRow: CGFloat
        if traitCollection.horizontalSizeClass == .compact
            && traitCollection.verticalSizeClass == .regular {  // iPhones portrait
            itemsPerRow = 1
        } else if traitCollection.verticalSizeClass == .compact {  // iPhones landscape
            itemsPerRow = 2
        } else {  // iPads
            itemsPerRow = 3
        }

        let availableWidth = collectionView.bounds.width - (margin_vertical * (itemsPerRow + 1))
        let itemWidth = availableWidth / itemsPerRow

        // Item height is equal to image view height (4th part of cell width and 2:3 aspect ratio)
        let itemHeight = itemWidth * 0.25 * 3 / 2
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
}


extension MediaItemsCategoryViewController {
    private func assignLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: margin_vertical, left: margin_horizontal, bottom: margin_vertical, right: margin_horizontal)
        layout.minimumInteritemSpacing = margin_vertical
        layout.minimumLineSpacing = margin_vertical
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
}
