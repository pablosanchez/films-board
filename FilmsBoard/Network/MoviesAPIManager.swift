//
//  MoviesAPIManager.swift
//  FilmsBoard
//
//  Created by Pablo on 11/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct MoviesAPIManager {

    typealias Completion = ([Int]?, Error?) -> ()  // Array of total pages for each category and if there's error
    typealias ErrorHandler = (Error?) -> ()

    private let apiCommunicator = MoviesAPICommunicator()
    private let dispatchGroup = DispatchGroup()

    let storage: MediaItemsStorage

    init(storage: MediaItemsStorage) {
        self.storage = storage
    }

    func getMediaItemsByCategories(type: MediaItemTypes, completion: @escaping Completion) {
        var totalPages = [Int](repeating: 0, count: MediaItemCategories.values.count)
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
                    let builderResult = try MediaItemsBuilder.decodeMediaItems(type: type, json: json)
                    totalPages[i] = builderResult.totalPages
                    result[currentCategory.rawValue] = builderResult.mediaItems
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
                completion(nil, error)
                return
            }

            for (key, value) in result {
                self.storage.addMediaItemsArray(value, forKey: key)
            }

            completion(totalPages, nil)
        }
    }

    func getMediaItems(for type: MediaItemTypes, category: MediaItemCategories,
                       page: Int, completion: @escaping ErrorHandler) {
        apiCommunicator.getMediaItems(type: type, category: category, page: page) { (jsonData, error) in
            guard let json = jsonData else {
                completion(error)
                return
            }

            do {
                let decodedJson = try MediaItemsBuilder.decodeMediaItems(type: type, json: json)
                self.storage.appendMediaItemsArray(decodedJson.mediaItems, forKey: category.rawValue)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    func getMediaItemsByText(text: String, type: MediaItemTypes, page: Int = 1, completion: @escaping Completion) {
        apiCommunicator.getMediaItems(forText: text, type: type, page: page) { (jsonData, error) in
            guard let json = jsonData else {
                completion(nil, error)
                return
            }

            do {
                let result = try MediaItemsBuilder.decodeMediaItems(type: type, json: json)
                let totalPages: [Int]? = [result.totalPages]
                let decodedJson = result.mediaItems
                if page == 1 {
                    self.storage.setMediaItemsArray(decodedJson)
                } else {
                    self.storage.appendMediaItemsArray(decodedJson)
                }
                completion(totalPages, nil)
            } catch {
                completion(nil, error)
            }
        }
    }

    func getMediaItemData(id: Int, type: MediaItemTypes, completion: @escaping ErrorHandler) {
        apiCommunicator.getMediaItemDetails(id: id, type: type) { (jsonData, error) in
            guard let json = jsonData else {
                completion(error)
                return
            }

            do {
                let decodedGenres = try MediaItemsBuilder.decodeMediaItemGenres(json: json)
                self.storage.currentMediaItemSelected.genres = decodedGenres
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    func getMediaItemTrailer(id: Int, type: MediaItemTypes, completion: @escaping (String?, Error?) -> ()) {
        apiCommunicator.getMediaItemTrailer(id: id, type: type) { (jsonData, error) in
            guard let json = jsonData else {
                completion(nil, error)
                return
            }

            do {
                let url = try MediaItemsBuilder.decodeMediaItemTrailerURL(json: json)
                completion(url, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
}
