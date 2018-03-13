//
//  PopularViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 13/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct PopularViewModel: MediaItemsRowViewModel {

    let title = "Más populares"

    let viewModels: [MediaItemViewModel]

    init(model: [MediaItem]) {
        self.viewModels = model.map { (mediaItem) -> MediaItemViewModel in
            return MediaItemViewModel(model: mediaItem)
        }
    }
}

extension PopularViewModel {

    func showMoreButtonTapped() {

    }
}
