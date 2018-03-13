//
//  TopRatedViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 13/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct TopRatedViewModel: MediaItemsRowViewModel {

    let title = "Mejor valorados"

    let viewModels: [MediaItemViewModel]

    init(model: [MediaItem]) {
        self.viewModels = model.map { (mediaItem) -> MediaItemViewModel in
            return MediaItemViewModel(model: mediaItem)
        }
    }
}

extension TopRatedViewModel {

    func showMoreButtonTapped() {

    }
}
