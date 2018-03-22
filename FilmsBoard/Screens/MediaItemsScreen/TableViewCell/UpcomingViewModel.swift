//
//  UpcomingViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct UpcomingViewModel: MediaItemsRowViewModel {

    let delegate: MediaItemsRowViewModelRoutingDelegate

    let title = MediaItemCategories.upcoming.getTitle()

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

extension UpcomingViewModel {

    func handleShowMoreButtonTap() {
        delegate.mediaItemsRowDidTapShowMoreButton(totalPages: numPages, category: MediaItemCategories.upcoming)
    }
}
