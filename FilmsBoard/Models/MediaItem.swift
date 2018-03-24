//
//  MediaItem.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

protocol MediaItem: Decodable {

    var id: Int { get }
    var posterImageURL: String { get }
    var backgroundImageURL: String { get }
    var title: String { get }
    var description: String { get }
    var releaseDate: String { get }
    var rating: Double { get }

    init(id: Int, posterImageURL: String?, backgroundImageURL: String?, title: String, description: String, releaseDate: String, rating: Double)
}
