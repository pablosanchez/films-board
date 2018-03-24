//
//  DetailedListViewModel.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 24/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

@objc
class DetailedListViewModel: NSObject {
    
    private let database: SQLiteDatabase
    private(set) var cellViewModels: [MediaItemDetailedCellViewModel] = []
    
    var listName: String?

    @objc
    init(database: SQLiteDatabase) {
        self.database = database
    }

    func setListName(name: String) {
        self.listName = name
    }
}

extension DetailedListViewModel {

    func loadListMediaItems(index: Int) {
        guard let name = listName else {
            return
        }

        let result = self.database.listMediaFromList(listName: name, type: index)

        self.cellViewModels = []
        for mediaItem in result {
            self.cellViewModels.append(MediaItemDetailedCellViewModel(model: mediaItem))
        }
    }
}

@objc
protocol DetailedListViewModelProvider: NSObjectProtocol {
    func detailedListViewModel() -> DetailedListViewModel
}
