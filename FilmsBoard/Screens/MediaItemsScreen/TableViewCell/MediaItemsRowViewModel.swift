//
//  MediaItemsRowViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

protocol MediaItemsRowViewModel {

    // The title for the cell
    var title: String { get }

    // Array of collection view cell view models
    var viewModels: [MediaItemViewModel] { get }

    // Designated initializer
    init(model: [MediaItem], delegate: MediaItemsRowViewModelRoutingDelegate)

    // Handle "Show more" button tap
    func handleShowMoreButtonTap()

    // Entity that will receive "Show more" button tap event
    var delegate: MediaItemsRowViewModelRoutingDelegate { get }
}
