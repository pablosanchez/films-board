//
//  TrailerViewModel.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 22/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation


@objc class TrailerViewModel: NSObject {
    
    private let storage: MediaItemsStorage
    var delegate: TrailerViewModelDelegate?
    
    
    @objc init(storage: MediaItemsStorage) {
        self.storage = storage
    }
    
    
    func trailerVideoExtension() -> String {
        
        return "Rwf8eS3isWk"
    }
    
    
    func closeTrailer() {
        delegate?.trailerHasBeenClosed()
    }
    
    
}

protocol TrailerViewModelDelegate: class {
    func trailerHasBeenClosed()
}
