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
    
    
    
}

@objc protocol DetailFilmViewModelProvider: NSObjectProtocol {
    func detailFilmViewModel() -> DetailFilmViewModel
}
