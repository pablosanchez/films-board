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

        apiManager.getMediaItemsByCategories(type: type) { (error) in
            guard error == nil, self.storage.mediaItemsByCategories.count == MovieTypes.values.count else {
                if let error = error as? MoviesAPIError {
                    switch error {
                    case .networkUnavailable:
                        print("sin red")
                    case .apiError(let code):
                        print(code)
                    }
                } else if let error = error as? MediaItemsBuilderError {
                    print("error -> \(error.errorMessage)")
                }

                return
            }

            self.tableCellViewModels = [
                NowPlayingViewModel(model: self.storage.mediaItemsByCategories[0]),
                UpcomingViewModel(model: self.storage.mediaItemsByCategories[1]),
                TopRatedViewModel(model: self.storage.mediaItemsByCategories[2]),
                PopularViewModel(model: self.storage.mediaItemsByCategories[3])
            ]

            self.delegate?.mediaItemsViewModelDidUpdateData(self)
        }
    }
}

protocol MediaItemsViewModelDelegate: class {
    func mediaItemsViewModelDidUpdateData(_ viewModel: MediaItemsViewModel)
}
