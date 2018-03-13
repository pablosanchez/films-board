//
//  Movie.swift
//  FilmsBoard
//
//  Created by Pablo on 11/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

struct Movie: MediaItem {

    private enum Keys: String, CodingKey {
        case imageURL = "poster_path"
        case title = "title"
    }

    private let imageBaseURL = "https://image.tmdb.org/t/p/w154"

    let posterImageURL: String
    let title: String

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        let imagePath = try values.decode(String.self, forKey: .imageURL)
        self.posterImageURL = "\(self.imageBaseURL)\(imagePath)"
        self.title = try values.decode(String.self, forKey: .title)
    }
}
