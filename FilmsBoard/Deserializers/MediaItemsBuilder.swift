//
//  MediaItemsBuilder.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct MediaItemsBuilder {

    static func decodeMediaItems(json rawJson: Any) throws -> [MediaItem] {
        guard let dictJson = rawJson as? [String: Any] else {
            throw MediaItemsBuilderError(errorMessage: "Error parsing media items json")
        }

        guard let mediaItemsJson = dictJson["results"] as? [[String: Any]] else {
            throw MediaItemsBuilderError(errorMessage: "Error parsing results json key")
        }

        guard let mediaItemsData = try? JSONSerialization.data(withJSONObject: mediaItemsJson, options: []) else {
            throw MediaItemsBuilderError(errorMessage: "Error serializing json to data")
        }

        guard let mediaItems = try? JSONDecoder().decode([Movie].self, from: mediaItemsData) else {
            throw MediaItemsBuilderError(errorMessage: "Error building media items from json")
        }

        return mediaItems
    }
}
