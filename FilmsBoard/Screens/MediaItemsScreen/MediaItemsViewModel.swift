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
    private let apiManager: MoviesAPIManager

    private(set) var type: MediaItemTypes!

    weak var delegate: MediaItemsViewModelDelegate?
    weak var routingDelegate: MediaItemsViewModelRoutingDelegate?

    @objc
    init(storage: MediaItemsStorage, apiManagerProvider: MoviesAPIManagerProvider) {
        self.storage = storage
        self.tableCellViewModels = []
        self.apiManager = apiManagerProvider.moviesAPIManager()
    }
}

extension MediaItemsViewModel {

    func getMediaItemsByCategories(index: Int) {
        self.type = MediaItemTypes(rawValue: index) ?? MediaItemTypes.movies

        self.apiManager.getMediaItemsByCategories(type: type) { [unowned self] (totalPages, error) in
            // Be sure there's no error and totalPages array size is just number of media item types
            guard let pages = totalPages, pages.count == MediaItemCategories.values.count, error == nil,
                self.storage.mediaItemsByCategories.count == MediaItemCategories.values.count else {
                var errorMsg = ""
                if let error = error as? HTTPRequestError {
                    errorMsg = error.message
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
                    model: self.storage.mediaItemsByCategories[MediaItemCategories.nowPlaying.rawValue] ?? [],
                    numPages: pages[0],
                    delegate: self
                ),
                UpcomingViewModel(
                    model: self.storage.mediaItemsByCategories[MediaItemCategories.upcoming.rawValue] ?? [],
                    numPages: pages[1],
                    delegate: self
                ),
                TopRatedViewModel(
                    model: self.storage.mediaItemsByCategories[MediaItemCategories.topRated.rawValue] ?? [],
                    numPages: pages[2],
                    delegate: self
                ),
                PopularViewModel(
                    model: self.storage.mediaItemsByCategories[MediaItemCategories.popular.rawValue] ?? [],
                    numPages: pages[3],
                    delegate: self
                )
            ]

            self.delegate?.mediaItemsViewModelDidUpdateData(self)
        }
    }
}

extension MediaItemsViewModel: MediaItemsRowViewModelRoutingDelegate {

    func mediaItemsRowDidTapShowMoreButton(totalPages: Int?, category: MediaItemCategories) {
        routingDelegate?.mediaItemsDidTapShowMoreButton(totalPages: totalPages, type: self.type, category: category)
    }
}

protocol MediaItemsViewModelRoutingDelegate: class {
    func mediaItemsDidTapShowMoreButton(totalPages: Int?, type: MediaItemTypes, category: MediaItemCategories)
}

protocol MediaItemsViewModelDelegate: class {
    func mediaItemsViewModelDidUpdateData(_ viewModel: MediaItemsViewModel)
    func mediaItemsViewModel(_ viewModel: MediaItemsViewModel, didGetError errorMessage: String)
}

@objc
protocol MediaItemsViewModelProvider: NSObjectProtocol {
    func mediaItemsViewModel() -> MediaItemsViewModel
}
