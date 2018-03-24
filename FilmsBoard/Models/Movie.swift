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
        case id = "id"
        case imageURL = "poster_path"
        case backImageURL = "backdrop_path"
        case title = "title"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case description = "overview"
    }

    private let imageBaseURL = "https://image.tmdb.org/t/p/w154"

    let id: Int
    var posterImageURL: String
    var backgroundImageURL: String
    let title: String
    let description: String
    let releaseDate: String
    let rating: Double
    let type: MediaItemTypes
    var genres: [String]?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        do {
            let imagePath = try values.decode(String.self, forKey: .imageURL)
            self.posterImageURL = "\(self.imageBaseURL)\(imagePath)"
        } catch {
            self.posterImageURL = "https://upload.wikimedia.org/wikipedia/commons/2/2b/No-Photo-Available-240x300.jpg"
        }
        do {
            let imagePath = try values.decode(String.self, forKey: .backImageURL)
            self.backgroundImageURL = "\(self.imageBaseURL)\(imagePath)"
        } catch {
            self.backgroundImageURL = "https://upload.wikimedia.org/wikipedia/commons/2/2b/No-Photo-Available-240x300.jpg"
        }
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try values.decode(String.self, forKey: .description)
        let unformattedReleaseDate = try values.decode(String.self, forKey: .releaseDate)
        self.releaseDate = unformattedReleaseDate.formatDate()
        self.rating = try values.decode(Double.self, forKey: .rating) / 2
        self.type = MediaItemTypes.movies
    }
    
    init(id: Int, posterImageURL: String?, backgroundImageURL: String?, title: String, description: String, releaseDate: String, rating: Double) {
        self.id = id
        self.posterImageURL = posterImageURL ?? "https://upload.wikimedia.org/wikipedia/commons/2/2b/No-Photo-Available-240x300.jpg"
        self.backgroundImageURL = backgroundImageURL ?? "https://upload.wikimedia.org/wikipedia/commons/2/2b/No-Photo-Available-240x300.jpg"
        self.title = title
        self.description = description
        self.releaseDate = releaseDate
        self.rating = rating
        self.type = MediaItemTypes.movies
    }
}
