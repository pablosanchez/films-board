//
//  MoviesAPIManager.swift
//  FilmsBoard
//
//  Created by Pablo on 11/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct MoviesAPIManager {

    private let apiCommunicator = MoviesAPICommunicator()
    private let dispatchGroup = DispatchGroup()

    let storage: MediaItemsStorage

    init(storage: MediaItemsStorage) {
        self.storage = storage
    }

    func getMediaItemsByCategories(type: MediaItemTypes, completionHandler: @escaping (Error?) -> ()) {
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

    private func getMoviesByCategories(completionHandler: @escaping (Error?) -> ()) {
        var result = [[MediaItem]](repeating: [], count: MovieTypes.values.count)
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
                    result[i] = try MediaItemsBuilder.decodeMediaItems(json: json)
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

            for (i, array) in result.enumerated() {
                self.storage.addMediaItemsArray(array, at: i)
            }

            completionHandler(nil)
        }
    }
}
