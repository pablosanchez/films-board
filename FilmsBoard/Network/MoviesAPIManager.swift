//
//  MoviesAPIManager.swift
//  FilmsBoard
//
//  Created by Pablo on 11/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct MoviesAPIManager {

    typealias ErrorHandler = (Error?) -> ()

    private let apiCommunicator = MoviesAPICommunicator()
    private let dispatchGroup = DispatchGroup()

    let storage: MediaItemsStorage

    init(storage: MediaItemsStorage) {
        self.storage = storage
    }

    func getMediaItemsByCategories(type: MediaItemTypes, completionHandler: @escaping ErrorHandler) {
        switch type {
        case .movies:
            self.getMoviesByCategories { (error) in
                completionHandler(error)
            }
        case .tvShows:
            print("not implemented yet")
            completionHandler(nil)
        }
    }

    func getMediaItemsCategory(_ category: MovieTypes, forPage page: Int, completionHandler: @escaping ErrorHandler) {
        apiCommunicator.getMovies(type: category, page: page) { (jsonData, error) in
            guard let json = jsonData else {
                // TODO: manage errors
                return
            }

            do {
                let decodedJson = try MediaItemsBuilder.decodeMediaItems(json: json)
                self.storage.appendMediaItemsArray(decodedJson.mediaItems, forKey: category.rawValue)
                self.storage.totalPages = decodedJson.totalPages
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
        }
    }

    private func getMoviesByCategories(completionHandler: @escaping ErrorHandler) {
        var result = [String: [MediaItem]]()
        var failed = false
        var errorReceived: Error?

        for (i, currentType) in MovieTypes.values.enumerated() {
            dispatchGroup.enter()
            apiCommunicator.getMovies(type: currentType) { (jsonData, error) in
                guard let json = jsonData else {
                    failed = true
                    errorReceived = error
                    self.dispatchGroup.leave()
                    return
                }

                do {
                    result[currentType.rawValue] = try (MediaItemsBuilder.decodeMediaItems(json: json)).mediaItems
                } catch {
                    failed = true
                    errorReceived = error
                }

                defer {  // In both cases (do-catch), leave the group
                    self.dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            if failed {
                completionHandler(errorReceived)
                return
            }

            for (key, value) in result {
                self.storage.addMediaItemsArray(value, forKey: key)
            }

            completionHandler(nil)
        }
    }
}
