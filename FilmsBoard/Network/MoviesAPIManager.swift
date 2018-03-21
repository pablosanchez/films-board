//
//  MoviesAPIManager.swift
//  FilmsBoard
//
//  Created by Pablo on 11/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct MoviesAPIManager {

    typealias Completion = (Error?) -> ()

    private let apiCommunicator = MoviesAPICommunicator()
    private let dispatchGroup = DispatchGroup()

    let storage: MediaItemsStorage

    init(storage: MediaItemsStorage) {
        self.storage = storage
    }

    func getMediaItemsByCategories(type: MediaItemTypes, completion: @escaping Completion) {
        var result = [String: [MediaItem]]()
        var errorReceived: Error? = nil

        for (i, currentCategory) in MediaItemCategories.values.enumerated() {
            dispatchGroup.enter()
            apiCommunicator.getMediaItems(type: type, category: currentCategory) { (jsonData, error) in
                guard let json = jsonData else {
                    errorReceived = error
                    self.dispatchGroup.leave()
                    return
                }

                do {
                    result[currentCategory.rawValue] =
                        try (MediaItemsBuilder.decodeMediaItems(type: type, json: json)).mediaItems
                } catch {
                    errorReceived = error
                }

                defer {  // In both cases (do-catch), leave the group
                    self.dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            if let error = errorReceived {  // Notify the error if there is one
                completion(error)
                return
            }

            for (key, value) in result {
                self.storage.addMediaItemsArray(value, forKey: key)
            }

            completion(nil)
        }
    }

    func getMediaItems(for type: MediaItemTypes, category: MediaItemCategories,
                       page: Int, completion: @escaping Completion) {
        apiCommunicator.getMediaItems(type: type, category: category, page: page) { (jsonData, error) in
            guard let json = jsonData else {
                // TODO: manage errors
                return
            }

            do {
                let decodedJson = try MediaItemsBuilder.decodeMediaItems(type: type, json: json)
                self.storage.appendMediaItemsArray(decodedJson.mediaItems, forKey: category.rawValue)
                self.storage.totalPages = decodedJson.totalPages
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
