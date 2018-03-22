//
//  MediaItem.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

protocol MediaItem: Decodable {

    var posterImageURL: String? { get }
    var title: String { get }
    var releaseDate: String { get }
    var rating: Double { get }
}
