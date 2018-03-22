//
//  TopRatedViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 13/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct TopRatedViewModel: MediaItemsRowViewModel {

    let delegate: MediaItemsRowViewModelRoutingDelegate

    let title = MediaItemCategories.topRated.getTitle()

    let viewModels: [MediaItemViewModel]

    var numPages: Int?

    init(model: [MediaItem], numPages: Int? = nil, delegate: MediaItemsRowViewModelRoutingDelegate) {
        self.viewModels = model.map { (mediaItem) -> MediaItemViewModel in
            return MediaItemViewModel(model: mediaItem)
        }
        self.numPages = numPages
        self.delegate = delegate
    }
}

extension TopRatedViewModel {

    func handleShowMoreButtonTap() {
        delegate.mediaItemsRowDidTapShowMoreButton(totalPages: numPages, category: MediaItemCategories.topRated)
    }
}
