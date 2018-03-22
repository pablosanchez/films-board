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
        
        case id = "id"
    }

    private let imageBaseURL = "https://image.tmdb.org/t/p/w154"

    let posterImageURL: String
    let backgroundImageURL: String
    let title: String
    let year: String
    let description: String
    let rating: Float
    
    let id: Int
    
    
    
    init(posterImageURL: String, backgroundImageURL: String, title: String, year: String, description: String, rating: Float, id: Int) {
        self.posterImageURL = posterImageURL
        self.backgroundImageURL = backgroundImageURL
        self.title = title
        self.year = year
        self.description = description
        self.rating = rating
        
        self.id = id
    }
    
    

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        
        let imagePath = try values.decode(String.self, forKey: .imageURL)
        
        let backImagePath = try values.decode(String.self, forKey: .backImageURL)
        
        
        self.posterImageURL = "\(self.imageBaseURL)\(imagePath)"
        self.backgroundImageURL = "\(self.imageBaseURL)\(backImagePath)"
        self.title = try values.decode(String.self, forKey: .title)
        self.year = try values.decode(String.self, forKey: .year)
        self.description = try values.decode(String.self, forKey: .description)
        self.rating = try values.decode(Float.self, forKey: .rating)
        
        self.id = try values.decode(Int.self, forKey: .id)
    }
}
