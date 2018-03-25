//
//  TrailerViewModel.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 22/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

@objc
class TrailerViewModel: NSObject {
    
    private let storage: MediaItemsStorage
    private let mediaItem: MediaItem
    private let apiManager: MoviesAPIManager

    weak var delegate: TrailerViewModelDelegate?
    weak var routingDelegate: TrailerViewModelRoutingDelegate?

    @objc
    init(storage: MediaItemsStorage, apiManagerProvider: MoviesAPIManagerProvider) {
        self.storage = storage
        self.mediaItem = storage.currentMediaItemSelected
        self.apiManager = apiManagerProvider.moviesAPIManager()
    }

    func closeTrailer() {
        routingDelegate?.trailerViewModelDidTapCloseButton(self)
    }
}

extension TrailerViewModel {

    func getTrailer() {
        self.apiManager.getMediaItemTrailer(id: self.mediaItem.id, type: self.mediaItem.type) { (key, error) in
            guard error == nil else {
                var errorMsg = ""
                if let error = error as? HTTPRequestError {
                    errorMsg = error.message
                } else if let error = error as? MediaItemsBuilderError {
                    errorMsg = error.errorMessage
                } else {
                    errorMsg = "Error desconocido"
                }

                self.delegate?.trailerViewModel(self, didGetError: errorMsg)
                return
            }

            if let key = key {
                let url = "https://www.youtube.com/embed/\(key)"
                self.delegate?.trailerViewModel(self, didGetUrl: URL(string: url)!)
            } else {
                self.delegate?.trailerViewModel(self, didGetError: "No hay url")
            }
        }
    }
}

protocol TrailerViewModelDelegate: class {
    func trailerViewModel(_ viewModel: TrailerViewModel, didGetUrl url: URL)
    func trailerViewModel(_ viewModel: TrailerViewModel, didGetError error: String)
}

protocol TrailerViewModelRoutingDelegate: class {
    func trailerViewModelDidTapCloseButton(_ viewModel: TrailerViewModel)
}
