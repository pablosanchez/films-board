//
//  MediaItemsViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 07/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

@objc
class MediaItemsViewModel: NSObject {

    private(set) var tableCellViewModels: [MediaItemsRowViewModel]
    private let storage: MediaItemsStorage

    weak var delegate: MediaItemsViewModelDelegate?
    var cellDelegate: MediaItemsCellSelectedDelegate?       //weak

    @objc
    init(storage: MediaItemsStorage) {
        self.storage = storage
        self.tableCellViewModels = []
    }
}

extension MediaItemsViewModel {

    func getMediaItemsByCategories(type: MediaItemTypes) {
        let apiManager = MoviesAPIManager(storage: storage)

        apiManager.getMediaItemsByCategories(type: type) { [unowned self] (error) in
            guard error == nil, self.storage.mediaItemsByCategories.count == MovieTypes.values.count else {
                if let error = error as? MoviesAPIError {
                    switch error {
                    case .networkUnavailable(let errorMessage):
                        self.delegate?.mediaItemsViewModel(self, didGetError: errorMessage)
                    case .apiError(let code):
                        self.delegate?.mediaItemsViewModel(self, didGetError: "Error de red: código HTTP \(code)")
                    }
                } else if let error = error as? MediaItemsBuilderError {
                    self.delegate?.mediaItemsViewModel(self, didGetError: error.errorMessage)
                }

                return
            }

            self.tableCellViewModels = [
                NowPlayingViewModel(model: self.storage.mediaItemsByCategories[0], delegate: self),
                UpcomingViewModel(model: self.storage.mediaItemsByCategories[1], delegate: self),
                TopRatedViewModel(model: self.storage.mediaItemsByCategories[2], delegate: self),
                PopularViewModel(model: self.storage.mediaItemsByCategories[3], delegate: self)
            ]

            self.delegate?.mediaItemsViewModelDidUpdateData(self)
        }
    }
}

extension MediaItemsViewModel: MediaItemsRowDidSelectCell {
    func handleCellTap(mediaItem: MediaItem, isUpcoming: Bool) {
        self.storage.addCurrentIdMovieSelected(mediaItem: mediaItem)
        cellDelegate?.cellTapped(mediaItem: mediaItem, isUpcoming: isUpcoming)
    }
}


protocol MediaItemsCellSelectedDelegate: class {
    func cellTapped(mediaItem: MediaItem, isUpcoming: Bool)
}



protocol MediaItemsViewModelDelegate: class {
    func mediaItemsViewModelDidUpdateData(_ viewModel: MediaItemsViewModel)
    func mediaItemsViewModel(_ viewModel: MediaItemsViewModel, didGetError errorMessage: String)
}
