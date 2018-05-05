//
//  MoviesAPICommunicator.swift
//  FilmsBoard
//
//  Created by Pablo on 11/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import Alamofire

@objc
class MoviesAPICommunicator: NSObject {

    typealias Completion = (Any?, RequestError?) -> ()

    private let baseURL: String
    private let apiKey: String
    private let networkReachability: NetworkReachability

    @objc
    init(networkReachability: NetworkReachability) {
        self.baseURL = "https://api.themoviedb.org/3"
        self.apiKey = "0d06d23f426db55f6986eea80871323f"
        self.networkReachability = networkReachability
    }

    func getMediaItems(type: MediaItemTypes, category: MediaItemCategories,
                       page: Int = 1, completion: @escaping Completion) {
        guard page > 0 else {
            let error = "Page must be greater than 0"
            completion(nil, RequestError(message: error))
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
            let error = "Page must be greater than 0"
            completion(nil, RequestError(message: error))
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
        guard self.networkReachability.connection else {  // There is no network connection
            let error = "No hay conexion de red disponible. Vuelve a intentarlo más tarde"
            completion(nil, RequestError(message: error))
            return
        }

        Alamofire
            .request(url,
                     parameters: parameters,
                     encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { (json) in
                switch json.result {
                case .failure:
                    var error = ""
                    if let response = json.response {
                        error = "Código de error \(response.statusCode)"
                    } else {
                        error = "Error desconocido"
                    }
                    completion(nil, RequestError(message: error))
                case .success(let json):
                    completion(json, nil)
                }
            }
    }
}

@objc
protocol MoviesAPICommunicatorProvider: NSObjectProtocol {
    func moviesAPICommunicator() -> MoviesAPICommunicator
}
