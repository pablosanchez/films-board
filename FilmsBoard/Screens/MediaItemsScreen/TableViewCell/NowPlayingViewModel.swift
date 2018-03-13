//
//  NowPlayingViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct NowPlayingViewModel: MediaItemsRowViewModel {

    let title = "Ahora en cartelera"

    let viewModels: [MediaItemViewModel]

    init(model: [MediaItem]) {
        self.viewModels = model.map { (mediaItem) -> MediaItemViewModel in
            return MediaItemViewModel(model: mediaItem)
        }
    }
}

extension NowPlayingViewModel {

    func showMoreButtonTapped() {

    }
}
