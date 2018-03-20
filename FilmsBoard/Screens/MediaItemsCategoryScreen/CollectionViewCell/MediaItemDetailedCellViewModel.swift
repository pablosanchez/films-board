//
//  MediaItemDetailedCellViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 20/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct MediaItemDetailedCellViewModel {

    private let model: MediaItem

    init(model: MediaItem) {
        self.model = model
    }

    var posterImageURL: String {
        return model.posterImageURL
    }

    var title: String {
        return model.title
    }

    var releaseDate: String {
        return model.releaseDate
    }

    var rating: Double {
        return model.rating
    }
}
