//
//  MediaItemsStorage.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

@objc
class MediaItemsStorage: NSObject {

    private(set) var mediaItemsByCategories: [[MediaItem]] = []
    private(set) var currentIdMovieSelected: MediaItem?
    
    func addCurrentIdMovieSelected(mediaItem: MediaItem) {
        self.currentIdMovieSelected = mediaItem
    }

    func addMediaItemsArray(_ mediaItems: [MediaItem], at position: Int) {
        self.mediaItemsByCategories.insert(mediaItems, at: position)
    }
}
