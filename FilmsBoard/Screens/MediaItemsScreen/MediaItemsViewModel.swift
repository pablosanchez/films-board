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
            // Be sure there's no error and media items dictionary contains just number of movie types keys
            guard error == nil, self.storage.mediaItemsByCategories.count == MovieTypes.values.count else {
                var errorMsg = ""
                if let error = error as? MoviesAPIError {
                    switch error {
                    case .networkUnavailable(let errorMessage):
                        errorMsg = errorMessage
                    case .apiError(let code):
                        errorMsg = "Error de red: código HTTP \(code)"
                    }
                } else if let error = error as? MediaItemsBuilderError {
                    errorMsg = error.errorMessage
                } else {
                    errorMsg = "Error desconocido"
                }

                self.delegate?.mediaItemsViewModel(self, didGetError: errorMsg)
                return
            }

            self.tableCellViewModels = [
                NowPlayingViewModel(
                    model: self.storage.mediaItemsByCategories[MovieTypes.nowPlaying.rawValue] ?? []),
                UpcomingViewModel(
                    model: self.storage.mediaItemsByCategories[MovieTypes.upcoming.rawValue] ?? []),
                TopRatedViewModel(
                    model: self.storage.mediaItemsByCategories[MovieTypes.topRated.rawValue] ?? []),
                PopularViewModel(
                    model: self.storage.mediaItemsByCategories[MovieTypes.popular.rawValue] ?? [])
            ]

            self.delegate?.mediaItemsViewModelDidUpdateData(self)
        }
    }
}

protocol MediaItemsViewModelDelegate: class {
    func mediaItemsViewModelDidUpdateData(_ viewModel: MediaItemsViewModel)
    func mediaItemsViewModel(_ viewModel: MediaItemsViewModel, didGetError errorMessage: String)
}

@objc
protocol MediaItemsViewModelProvider: NSObjectProtocol {
    func mediaItemsViewModel() -> MediaItemsViewModel
}
