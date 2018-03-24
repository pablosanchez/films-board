//
//  NowPlayingViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct NowPlayingViewModel: MediaItemsRowViewModel {

    let title = MediaItemCategories.nowPlaying.getTitle()
    let models: [MediaItem]
    let viewModels: [MediaItemViewModel]

    var numPages: Int?

    let delegate: MediaItemsRowDidSelectCell
    let routingDelegate: MediaItemsRowViewModelRoutingDelegate

    init(model: [MediaItem], numPages: Int? = nil, delegate: MediaItemsRowDidSelectCell, routingDelegate: MediaItemsRowViewModelRoutingDelegate) {
        self.models = model
        self.viewModels = model.map { (mediaItem) -> MediaItemViewModel in
            return MediaItemViewModel(model: mediaItem)
        }
        self.numPages = numPages
        self.delegate = delegate
        self.routingDelegate = routingDelegate
    }
}

extension NowPlayingViewModel {

    func handleShowMoreButtonTap() {
        routingDelegate.mediaItemsRowDidTapShowMoreButton(totalPages: numPages, category: MediaItemCategories.nowPlaying)
    }
    
    func selectedItem(index: Int) {
        let mediaItem = self.models[index]
        self.delegate.handleCellTap(mediaItem: mediaItem)
    }
}
