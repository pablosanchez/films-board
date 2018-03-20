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
        case backImageURL = "backdrop_path"
        case title = "title"
        case year = "release_date"
        case description = "overview"
        case rating = "vote_average"
    }

    private let imageBaseURL = "https://image.tmdb.org/t/p/w154"

    let posterImageURL: String
    let backgroundImageURL: String
    let title: String
    let year: String
    let description: String
    let rating: String
    

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        
        let imagePath = try values.decode(String.self, forKey: .imageURL)
        
        let backImagePath = try values.decode(String.self, forKey: .backImageURL)
        
        
        self.posterImageURL = "\(self.imageBaseURL)\(imagePath)"
        self.backgroundImageURL = "\(self.imageBaseURL)\(backImagePath)"
        self.title = try values.decode(String.self, forKey: .title)
        self.year = try values.decode(String.self, forKey: .year)
        self.description = try values.decode(String.self, forKey: .description)
        self.rating = try values.decode(String.self, forKey: .rating)
    }
}
