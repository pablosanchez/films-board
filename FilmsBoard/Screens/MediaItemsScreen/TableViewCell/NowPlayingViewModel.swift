//
//  NowPlayingViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct NowPlayingViewModel: MediaItemsRowViewModel {
    
    let delegate: MediaItemsRowDidSelectCell
    let title = "Ahora en cartelera"
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

extension NowPlayingViewModel {

    func showMoreButtonTapped() {

    }
    
    
    func selectedItem(index: Int)
    {
        let mediaItem = self.models[index]
        self.delegate.handleCellTap(mediaItem: mediaItem, isUpcoming: false)
    }
}
