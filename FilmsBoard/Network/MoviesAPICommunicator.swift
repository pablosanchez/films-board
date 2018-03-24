//
//  MoviesAPICommunicator.swift
//  FilmsBoard
//
//  Created by Pablo on 11/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import Alamofire

struct MoviesAPICommunicator {

    typealias Completion = (Any?, MoviesAPIError?) -> ()

    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "0d06d23f426db55f6986eea80871323f"

    func getMediaItems(type: MediaItemTypes, category: MediaItemCategories,
                       page: Int = 1, completion: @escaping Completion) {
        guard page > 0 else {
            return
        }

        let url = self.getUrl(for: type, category: category)
        let params: [String: Any] = ["api_key": self.apiKey, "language": "es", "page": page]

        self.doRequest(url: url, parameters: params) { (jsonData, error) in
            completion(jsonData, error)
        }
    }

    func getMediaItems(forText text: String, type: MediaItemTypes, page: Int, completion: @escaping Completion) {
        guard page > 0 else {
            return
        }

        var url: String

        switch type {
        case .movies:
            url = "\(baseURL)/search/movie"
        case .tvShows:
            url = "\(baseURL)/search/tv"
        }

        let params: [String: Any] = ["api_key": self.apiKey, "language": "es", "query": text, "page": page]

        self.doRequest(url: url, parameters: params) { (jsonData, error) in
            completion(jsonData, error)
        }
    }

    func getMediaItemDetails(id: Int, type: MediaItemTypes, completion: @escaping Completion) {
        var url: String

        switch type {
        case .movies:
            url = "\(baseURL)/movie/\(id)"
        case .tvShows:
            url = "\(baseURL)/tv/\(id)"
        }

        let params: [String: Any] = ["api_key": self.apiKey, "language": "es"]

        self.doRequest(url: url, parameters: params) { (jsonData, error) in
            completion(jsonData, error)
        }
    }

    func getMediaItemTrailer(id: Int, type: MediaItemTypes, completion: @escaping Completion) {
        var url: String

        switch type {
        case .movies:
            url = "\(baseURL)/movie"
        case .tvShows:
            url = "\(baseURL)/tv"
        }

        url.append("/\(id)/videos")
        let params: [String: Any] = ["api_key": self.apiKey, "language": "en"]

        self.doRequest(url: url, parameters: params) { (jsonData, error) in
            completion(jsonData, error)
        }
    }

    private func getUrl(for type: MediaItemTypes, category: MediaItemCategories) -> String {
        var url: String

        switch type {
        case .movies:
            url = "\(baseURL)/movie"
        case .tvShows:
            url = "\(baseURL)/tv"
        }

        switch category {
        case .nowPlaying:
            (type == .movies) ? url.append("/now_playing") : url.append("/airing_today")
        case .upcoming:
            (type == .movies) ? url.append("/upcoming") : url.append("/on_the_air")
        case .topRated:
            url.append("/top_rated")
        case .popular:
            url.append("/popular")
        }

        return url
    }

    private func doRequest(url: String, parameters: Parameters? = nil, completion: @escaping Completion) {
        Alamofire
            .request(url,
                     parameters: parameters,
                     encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { (json) in
                switch json.result {
                case .failure:
                    if let response = json.response {
                        completion(nil, MoviesAPIError.apiError(code: response.statusCode))
                    } else {
                        completion(nil, MoviesAPIError.networkUnavailable(errorMessage: "No hay conectividad de red disponible. Compruebe conexión de red y vuelva a intentarlo"))
                    }
                case .success(let json):
                    completion(json, nil)
                }
            }
    }
}
