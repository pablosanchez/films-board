//
//  SearchViewController.swift
//  FilmsBoard
//
//  Created by Pablo on 20/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!

    private var progressIndicator: MBProgressHUD!

    private let CELL_ID = "media-item-cell"
    private let margin: CGFloat = 10  // Collection view margin
    private let viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = searchBar
        self.initSearchBar()
        self.initSegmentedControl()
        self.initCollectionView()
    }

    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        self.performSearch()
    }
}

extension SearchViewController {

    private func initSearchBar() {
        self.searchBar.placeholder = "Buscar..."
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
    }

    private func initSegmentedControl() {
        self.segmentedControl.setTitle("Películas", forSegmentAt: 0)
        self.segmentedControl.setTitle("Series", forSegmentAt: 1)
    }

    private func initCollectionView() {
        let cellNib = UINib(nibName: "MediaItemDetailedCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: CELL_ID)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        self.collectionView.setCollectionViewLayout(layout, animated: false)

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

extension SearchViewController {

    func performSearch() {
        self.progressIndicator = MBProgressHUDBuilder.makeProgressIndicator(view: self.view)
        let index = self.segmentedControl.selectedSegmentIndex
        viewModel.performSearchRequest(text: searchBar.text, index: index)
    }
}

extension SearchViewController: UISearchBarDelegate {

    // MARK: UISearchBarDelegate methods

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        self.performSearch()
    }
}

extension SearchViewController: SearchViewModelDelegate {

    // MARK: SearchViewModelDelegate methods

    func searchViewModelDidUpdateData(_ viewModel: SearchViewModel) {
        self.progressIndicator.hide(animated: true)
        self.collectionView.reloadData()
    }

    func searchViewModelDidFinishUpdatingData(_ viewModel: SearchViewModel) {
        self.progressIndicator.hide(animated: true)
    }

    func searchViewModel(_ viewModel: SearchViewModel, didGetError errorMessage: String) {
        self.progressIndicator.hide(animated: true)
        SCLAlertViewBuilder()
            .setTitle("Aviso")
            .setSubtitle(errorMessage)
            .setCloseButtonTitle("Ok")
            .setCircleIconImage(UIImage(named: "ic-no-network"))
            .show()
    }
}

extension SearchViewController: UICollectionViewDataSource {

    // MARK: UICollectionViewDataSource methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! MediaItemDetailedCell
        cell.viewModel = viewModel.cellViewModels[indexPath.row]

        if indexPath.row == (viewModel.cellViewModels.count - 1) {  // Infinite scroll
            self.progressIndicator = MBProgressHUDBuilder.makeProgressIndicator(view: self.view)
            viewModel.getNextMediaItemsPage()
        }

        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    // MARK: UICollectionViewDelegateFlowLayout methods

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

        let availableWidth = collectionView.bounds.width - (margin * (itemsPerRow + 1))
        let itemWidth = availableWidth / itemsPerRow

        // Item height is equal to image view height (4th part of cell width and 2:3 aspect ratio)
        let itemHeight = itemWidth * 0.25 * 3 / 2
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
