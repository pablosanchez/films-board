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
        // Json is dictionary of string : any
        guard let dictJson = rawJson as? [String: Any] else {
            throw RequestError(message: "Error parsing media items json")
        }

        // Get total pages to do pagination
        guard let totalPages = dictJson["total_pages"] as? Int else {
            throw RequestError(message: "Error parsing media items json")
        }

        // Results is where the data is
        guard let mediaItemsJson = dictJson["results"] as? [[String: Any]] else {
            throw RequestError(message: "Error parsing results json key")
        }

        // Get json data in order to be able to use Decodable
        guard let mediaItemsData = try? JSONSerialization.data(withJSONObject: mediaItemsJson, options: []) else {
            throw RequestError(message: "Error serializing json to data")
        }

        var decodedMediaItems: [MediaItem]

        switch type {
        case .movies:
            guard let mediaItems = try? JSONDecoder().decode([Movie].self, from: mediaItemsData) else {
                throw RequestError(message: "Error building movies from json")
            }

            decodedMediaItems = mediaItems
        case .tvShows:
            guard let mediaItems = try? JSONDecoder().decode([TvShow].self, from: mediaItemsData) else {
                throw RequestError(message: "Error building series from json")
            }

            decodedMediaItems = mediaItems
        }

        return MediaItemsBuilderResult(mediaItems: decodedMediaItems, totalPages: totalPages)
    }

    static func decodeMediaItemGenres(json rawJson: Any) throws -> [String] {
        // Json is dictionary of string : any
        guard let dictJson = rawJson as? [String: Any] else {
            throw RequestError(message: "Error parsing media item details json")
        }

        // Genres is the data we are looking for
        guard let genresDict = dictJson["genres"] as? [[String: Any]] else {
            throw RequestError(message: "Error parsing genres json key")
        }

        var genres: [String] = []

        // We want the name of the genre, not its id
        for dict in genresDict {
            genres.append(dict["name"] as? String ?? "Desconocido")
        }

        return genres
    }

    static func decodeMediaItemTrailerURL(json rawJson: Any) throws -> String {
        // Json is dictionary of string : any
        guard let dictJson = rawJson as? [String: Any] else {
            throw RequestError(message: "Error parsing media item details json")
        }

        // Results is where trailer info is
        guard let resultsJson = dictJson["results"] as? [[String: Any]] else {
            throw RequestError(message: "Error parsing results json key")
        }

        // Be sure there is at least one trailer for this item
        guard resultsJson.count > 0 else {
            throw RequestError(message: "Error: no hay trailers en inglés para este item")
        }

        // We want the first trailer available
        guard let url = resultsJson[0]["key"] as? String else {
            throw RequestError(message: "Error getting trailer url")
        }

        return url
    }
}
