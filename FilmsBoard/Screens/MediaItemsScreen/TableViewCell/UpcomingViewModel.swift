//
//  UpcomingViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct UpcomingViewModel: MediaItemsRowViewModel {
    
    let delegate: MediaItemsRowDidSelectCell
    let title = "Próximamente"
    let models: [MediaItem]

    
    let viewModels: [MediaItemViewModel]

    init(model: [MediaItem], delegate: MediaItemsRowDidSelectCell) {
        self.delegate = delegate
        self.models = model
        self.viewModels = model.map { (mediaItem) -> MediaItemViewModel in
            return MediaItemViewModel(model: mediaItem)
        }
    }
}

extension UpcomingViewModel {

    func showMoreButtonTapped() {

    }
    
    func selectedItem(index: Int)
    {
        let mediaItem = self.models[index]
        self.delegate.handleCellTap(mediaItem: mediaItem, isUpcoming: true)
    }
}
