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

    private(set) var mediaItemsByCategories: [String: [MediaItem]]  // Store media items by categories
    private(set) var mediaItemsByTextSearch: [MediaItem]  // Store text-search results

    private(set) var currentMediaItemSelected: MediaItem!  // Store selected media item

    override init() {
        self.mediaItemsByCategories = [:]
        self.mediaItemsByTextSearch = []
    }

    func addMediaItemsArray(_ mediaItems: [MediaItem], forKey key: String) {
        self.mediaItemsByCategories[key] = mediaItems
    }

    func appendMediaItemsArray(_ mediaItems: [MediaItem], forKey key: String) {
        var array = mediaItemsByCategories[key]
        array?.append(contentsOf: mediaItems)
        self.mediaItemsByCategories[key] = array
    }

    func setMediaItemsArray(_ mediaItems: [MediaItem]) {
        self.mediaItemsByTextSearch = mediaItems
    }

    func appendMediaItemsArray(_ mediaItems: [MediaItem]) {
        self.mediaItemsByTextSearch.append(contentsOf: mediaItems)
    }

    func setCurrentMediaItem(mediaItem: MediaItem) {
        self.currentMediaItemSelected = mediaItem
    }
}
