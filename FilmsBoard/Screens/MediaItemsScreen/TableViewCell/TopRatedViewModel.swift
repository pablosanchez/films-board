//
//  TopRatedViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 13/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct TopRatedViewModel: MediaItemsRowViewModel {

    let title = MediaItemCategories.topRated.getTitle()
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

extension TopRatedViewModel {

    func handleShowMoreButtonTap() {
        routingDelegate.mediaItemsRowDidTapShowMoreButton(totalPages: numPages, category: MediaItemCategories.topRated)
    }
    
    func selectedItem(index: Int) {
        let mediaItem = self.models[index]
        self.delegate.handleCellTap(mediaItem: mediaItem)
    }
}
