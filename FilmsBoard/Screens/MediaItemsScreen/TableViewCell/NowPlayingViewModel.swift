//
//  NowPlayingViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct NowPlayingViewModel: MediaItemsRowViewModel {

    let delegate: MediaItemsRowViewModelRoutingDelegate

    let title = MediaItemCategories.nowPlaying.getTitle()

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

extension NowPlayingViewModel {

    func handleShowMoreButtonTap() {
        delegate.mediaItemsRowDidTapShowMoreButton(totalPages: numPages, category: MediaItemCategories.nowPlaying)
    }
}
