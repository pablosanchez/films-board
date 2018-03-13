//
//  UpcomingViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct UpcomingViewModel: MediaItemsRowViewModel {

    let title = "Próximamente"

    let viewModels: [MediaItemViewModel]

    init(model: [MediaItem]) {
        self.viewModels = model.map { (mediaItem) -> MediaItemViewModel in
            return MediaItemViewModel(model: mediaItem)
        }
    }
}

extension UpcomingViewModel {

    func showMoreButtonTapped() {

    }
}
