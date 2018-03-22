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
        case releaseDate = "release_date"
        case rating = "vote_average"
    }

    private let imageBaseURL = "https://image.tmdb.org/t/p/w154"

    var posterImageURL: String?
    let title: String
    let releaseDate: String
    let rating: Double

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        do {
            let imagePath = try values.decode(String.self, forKey: .imageURL)
            self.posterImageURL = "\(self.imageBaseURL)\(imagePath)"
        } catch {
            self.posterImageURL = nil
        }
        self.title = try values.decode(String.self, forKey: .title)
        let unformattedReleaseDate = try values.decode(String.self, forKey: .releaseDate)
        self.releaseDate = unformattedReleaseDate.formatDate()
        self.rating = try values.decode(Double.self, forKey: .rating) / 2
    }
}
