//
//  MovieTypes.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

enum MovieTypes {
    case nowPlaying
    case upcoming
    case topRated
    case popular

    static let values = [nowPlaying, upcoming, topRated, popular]
}
