//
//  MediaItem.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

protocol MediaItem: Decodable {

    var posterImageURL: String { get }
    var backgroundImageURL: String { get }
    var title: String { get }
    var year: String { get }
    var description: String { get }
    var rating: Float { get }
    
    var id: Int { get }
    
    init(posterImageURL: String, backgroundImageURL: String, title: String,
         year: String, description: String, rating: Float, id: Int)
    
}
