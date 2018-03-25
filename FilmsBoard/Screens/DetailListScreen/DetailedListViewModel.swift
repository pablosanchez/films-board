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

    private let storage: MediaItemsStorage
    private let database: SQLiteDatabase
    private(set) var cellViewModels: [MediaItemDetailedCellViewModel] = []
    private var mediaItems: [MediaItem] = []
    
    var listName: String?

    weak var routingDelegate: DetailedListViewModelRoutingDelegate?

    @objc
    init(storage: MediaItemsStorage, database: SQLiteDatabase) {
        self.storage = storage
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
        self.mediaItems = result

        self.cellViewModels = []
        for mediaItem in result {
            self.cellViewModels.append(MediaItemDetailedCellViewModel(model: mediaItem))
        }
    }
}

extension DetailedListViewModel {

    func selectedCell(withIndex index: Int) {
        let mediaItem = self.mediaItems[index]
        self.storage.setCurrentMediaItem(mediaItem: mediaItem)
        routingDelegate?.detailedListViewModelDidTapCell(self)
    }
}

protocol DetailedListViewModelRoutingDelegate: class {
    func detailedListViewModelDidTapCell(_ viewModel: DetailedListViewModel)
}

@objc
protocol DetailedListViewModelProvider: NSObjectProtocol {
    func detailedListViewModel() -> DetailedListViewModel
}
