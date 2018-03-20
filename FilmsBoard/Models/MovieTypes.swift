//
//  MovieTypes.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

enum MovieTypes: String {
    case nowPlaying = "nowPlaying"
    case upcoming = "upcoming"
    case topRated = "topRated"
    case popular = "popular"

    static let values = [nowPlaying, upcoming, topRated, popular]

    func getTitle() -> String {
        switch self {
        case .nowPlaying:
            return "Ahora en cartelera"
        case .upcoming:
            return "Próximamente"
        case .topRated:
            return "Mejor valorados"
        case .popular:
            return "Más populares"
        }
    }
}
