//
//  MediaItemsRowViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

protocol MediaItemsRowViewModel {

    /**
     The title for this table view cell
     */
    var title: String { get }
    
    
    var delegate: MediaItemsRowDidSelectCell { get }

    /**
     Array of collection view cell view models
     */
    var viewModels: [MediaItemViewModel] { get }

    /**
     Handle click on "Show more" button
     */
    func showMoreButtonTapped()
    
    
    /**
    Handle click cell
    */
    func selectedItem(index: Int)

    /**
     Designated initializer
     */
    init(model: [MediaItem], delegate: MediaItemsRowDidSelectCell)
}


protocol MediaItemsRowDidSelectCell {
    func handleCellTap(mediaItem: MediaItem, isUpcoming: Bool)
}
