//
//  DetailFilmViewModel.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 20/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation


@objc class DetailFilmViewModel: NSObject {
    
    private let storage: MediaItemsStorage
    
    @objc init(storage: MediaItemsStorage)
    {
        self.storage = storage
    }
    
    
    
    var mainImage: String {
        return storage.currentIdMovieSelected!.posterImageURL
    }
    
    var backImage: String {
        return storage.currentIdMovieSelected!.backgroundImageURL
    }
    
    var title: String {
        return storage.currentIdMovieSelected!.title
    }
    
    var year: String {
        return storage.currentIdMovieSelected!.year
    }
    
    var overview: String {
        return storage.currentIdMovieSelected!.description
    }
    
    var rating: Float {
        return storage.currentIdMovieSelected!.rating
    }
    
}

@objc protocol DetailFilmViewModelProvider: NSObjectProtocol {
    func detailFilmViewModel() -> DetailFilmViewModel
}
