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
    private let apiManager: MoviesAPIManager
    private var mediaItems: [MediaItem] = []

    private var currentPage: Int
    var totalPages: Int?  // To handle infinite scrolling

    var type: MediaItemTypes!

    var category: MediaItemCategories! {
        didSet {
            self.setTitle()
            self.updateCellViewModels()
        }
    }

    var title: String!

    weak var delegate: MediaItemsCategoryViewModelDelegate?
    weak var routingDelegate: MediaItemsCategoryViewModelRoutingDelegate?

    @objc
    init(storage: MediaItemsStorage, apiManagerProvider: MoviesAPIManagerProvider) {
        self.storage = storage
        currentPage = 1
        self.apiManager = apiManagerProvider.moviesAPIManager()
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

        self.mediaItems = mediaItems
        self.cellViewModels = mediaItems.map { (mediaItem) -> MediaItemDetailedCellViewModel in
            return MediaItemDetailedCellViewModel(model: mediaItem)
        }
    }
}

extension MediaItemsCategoryViewModel {

    func getNextMediaItemsPage() {
        self.currentPage += 1

        if currentPage > self.totalPages ?? 1 {  // If there were no pages, give a default value of 1
            self.delegate?.mediaItemsCategoryViewModelDidFinishUpdatingData(self)
            return
        }

        self.apiManager.getMediaItems(for: type, category: category, page: currentPage) { [unowned self] (error) in
            guard error == nil else {
                var errorMsg = ""
                if let error = error as? RequestError {
                    errorMsg = error.message
                } else {
                    errorMsg = "Error desconocido"
                }

                self.delegate?.mediaItemsCategoryViewModel(self, didGetError: errorMsg)
                return
            }

            self.updateCellViewModels()
            self.delegate?.mediaItemsCategoryViewModelDidUpdateData(self)
        }
    }
}

extension MediaItemsCategoryViewModel {

    func selectedCell(withIndex index: Int) {
        let mediaItem = self.mediaItems[index]
        self.storage.setCurrentMediaItem(mediaItem: mediaItem)
        routingDelegate?.mediaItemsCategoryViewModelDidTapCell(self)
    }
}

protocol MediaItemsCategoryViewModelDelegate: class {
    func mediaItemsCategoryViewModelDidUpdateData(_ viewModel: MediaItemsCategoryViewModel)
    func mediaItemsCategoryViewModelDidFinishUpdatingData(_ viewModel: MediaItemsCategoryViewModel)
    func mediaItemsCategoryViewModel(_ viewModel: MediaItemsCategoryViewModel, didGetError errorMessage: String)
}

protocol MediaItemsCategoryViewModelRoutingDelegate: class {
    func mediaItemsCategoryViewModelDidTapCell(_ viewModel: MediaItemsCategoryViewModel)
}

@objc
protocol MediaItemsCategoryViewModelProvider: NSObjectProtocol {
    func mediaItemsCategoryViewModel() -> MediaItemsCategoryViewModel
}
