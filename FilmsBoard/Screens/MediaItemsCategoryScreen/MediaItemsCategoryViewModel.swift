//
//  MediaItemsCategoryViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 19/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

@objc
class MediaItemsCategoryViewModel: NSObject {

    private let storage: MediaItemsStorage
    private(set) var cellViewModels: [MediaItemDetailedCellViewModel] = []
    private var currentPage: Int

    var category: MovieTypes! {
        didSet {
            self.setTitle()
            self.updateCellViewModels()
        }
    }

    var title: String!

    weak var delegate: MediaItemsCategoryViewModelDelegate?

    @objc
    init(storage: MediaItemsStorage) {
        self.storage = storage
        currentPage = 1
        super.init()
    }
}

extension MediaItemsCategoryViewModel {

    private func setTitle() {
        self.title = category.getTitle()
    }

    private func updateCellViewModels() {
        guard let mediaItems = storage.mediaItemsByCategories[category.rawValue] else {
            return
        }

        self.cellViewModels = mediaItems.map { (mediaItem) -> MediaItemDetailedCellViewModel in
            return MediaItemDetailedCellViewModel(model: mediaItem)
        }
    }
}

extension MediaItemsCategoryViewModel {

    func getNextMediaItemsPage() {
        let apiManager = MoviesAPIManager(storage: storage)
        self.currentPage += 1

        if (currentPage > self.storage.totalPages ?? 2) {  // Total pages is assigned on second request
            return
        }

        apiManager.getMediaItemsCategory(category, forPage: currentPage) { [unowned self] (error) in
            // TODO: manage errors
            guard error == nil else {
                return
            }

            self.updateCellViewModels()
            self.delegate?.mediaItemsCategoryViewModelDidUpdateData(self)
        }
    }
}

protocol MediaItemsCategoryViewModelDelegate: class {
    func mediaItemsCategoryViewModelDidUpdateData(_ viewModel: MediaItemsCategoryViewModel)
}

@objc
protocol MediaItemsCategoryViewModelProvider: NSObjectProtocol {
    func mediaItemsCategoryViewModel() -> MediaItemsCategoryViewModel
}

