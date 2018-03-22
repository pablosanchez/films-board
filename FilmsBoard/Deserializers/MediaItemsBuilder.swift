//
//  MediaItemsBuilder.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct MediaItemsBuilder {

    static func decodeMediaItems(type: MediaItemTypes, json rawJson: Any) throws -> MediaItemsBuilderResult {
        guard let dictJson = rawJson as? [String: Any] else {
            throw MediaItemsBuilderError(errorMessage: "Error parsing media items json")
        }

        guard let totalPages = dictJson["total_pages"] as? Int else {
            throw MediaItemsBuilderError(errorMessage: "Error parsing media items json")
        }

        guard let mediaItemsJson = dictJson["results"] as? [[String: Any]] else {
            throw MediaItemsBuilderError(errorMessage: "Error parsing results json key")
        }

        guard let mediaItemsData = try? JSONSerialization.data(withJSONObject: mediaItemsJson, options: []) else {
            throw MediaItemsBuilderError(errorMessage: "Error serializing json to data")
        }

        var decodedMediaItems: [MediaItem]

        switch type {
        case .movies:
            guard let mediaItems = try? JSONDecoder().decode([Movie].self, from: mediaItemsData) else {
                throw MediaItemsBuilderError(errorMessage: "Error building movies from json")
            }

            decodedMediaItems = mediaItems
        case .tvShows:
            guard let mediaItems = try? JSONDecoder().decode([TvShow].self, from: mediaItemsData) else {
                throw MediaItemsBuilderError(errorMessage: "Error building series from json")
            }

            decodedMediaItems = mediaItems
        }

        return MediaItemsBuilderResult(mediaItems: decodedMediaItems, totalPages: totalPages)
    }
}
