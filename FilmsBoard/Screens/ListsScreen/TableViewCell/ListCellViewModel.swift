//
//  ListCellViewModel.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 24/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation


struct ListCellViewModel {
    
    private let model: List
    
    init(model: List) {
        self.model = model
    }
    
    var title: String {
        return model.listName
    }
    
    var count: Int {
        return model.count
    }
}

