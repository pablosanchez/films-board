//
//  DetailedListViewModel.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 24/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation



@objc class DetailedListViewModel: NSObject {
    
    private let database: SQLiteDatabase
    private(set) var cellViewModels: [MediaItemDetailedCellViewModel] = []
    
    var listName: String?
    
    
    @objc init(database: SQLiteDatabase)
    {
        self.database = database
    }
    
    
    func setListName(name: String) {
        self.listName = name
    }
}



extension DetailedListViewModel {
    func loadListMediaItems()
    {
        if let name = listName {
            let result = self.database.listMediaFromList(listName: name, type: 0)
            
            for mediaItem in result {
                cellViewModels.append(MediaItemDetailedCellViewModel(model: mediaItem))
            }
        }

    }
}





@objc protocol DetailedListViewModelProvider: NSObjectProtocol {
    func detailedListViewModel() -> DetailedListViewModel
}
