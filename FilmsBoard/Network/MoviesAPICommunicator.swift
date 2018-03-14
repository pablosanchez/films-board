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

    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "0d06d23f426db55f6986eea80871323f"

    func getMovies(type: MovieTypes, page: Int = 1, completionHandler: @escaping (Any?, MoviesAPIError?) -> ()) {
        guard page > 0 else {
            return
        }

        var requestURL: String

        switch type {
        case .nowPlaying:
            requestURL = "\(baseURL)/movie/now_playing"
        case .upcoming:
            requestURL = "\(baseURL)/movie/upcoming"
        case .topRated:
            requestURL = "\(baseURL)/movie/top_rated"
        case .popular:
            requestURL = "\(baseURL)/movie/popular"
        }

        Alamofire
            .request(requestURL,
                     parameters: ["api_key": self.apiKey, "language": "es", "page": page],
                     encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { (json) in
                switch json.result {
                case .failure:
                    if let response = json.response {
                        completionHandler(nil, MoviesAPIError.apiError(code: response.statusCode))
                    } else {
                        completionHandler(nil, MoviesAPIError.networkUnavailable(errorMessage: "No hay conectividad de red disponible. Compruebe conexión de red y vuelva a intentarlo"))
                    }
                case .success(let json):
                    completionHandler(json, nil)
                }
            }
    }
}
