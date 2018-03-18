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

    private(set) var mediaItemsByCategories: [String: [MediaItem]]

    override init() {
        self.mediaItemsByCategories = [:]
    }

    func addMediaItemsArray(_ mediaItems: [MediaItem], forKey key: String) {
        self.mediaItemsByCategories[key] = mediaItems
    }
}
