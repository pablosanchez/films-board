//
//  TopRatedViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 13/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct TopRatedViewModel: MediaItemsRowViewModel {
    
    let delegate: MediaItemsRowDidSelectCell
    let title = "Mejor valorados"
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

extension TopRatedViewModel {

    func showMoreButtonTapped() {

    }
    
    func selectedItem(index: Int)
    {
        let mediaItem = self.models[index]
        self.delegate.handleCellTap(mediaItem: mediaItem, isUpcoming: false)
    }
}
