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

        for (i, currentType) in MovieTypes.values.enumerated() {
            dispatchGroup.enter()
            apiCommunicator.getMovies(type: currentType) { (jsonData, error) in
                guard let json = jsonData else {
                    completionHandler(error)
                    return
                }

                do {
                    result[i] = try MediaItemsBuilder.decodeMediaItems(json: json)
                    self.dispatchGroup.leave()
                } catch {
                    completionHandler(error)
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            for (i, array) in result.enumerated() {
                self.storage.addMediaItemsArray(array, at: i)
            }

            completionHandler(nil)
        }
    }
}
