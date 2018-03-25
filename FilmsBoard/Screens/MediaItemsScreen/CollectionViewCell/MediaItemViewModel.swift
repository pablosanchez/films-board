//
//  MediaItemViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct MediaItemViewModel {

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
    
    var id: Int {
        return model.id
    }
}
