//
//  ListsViewModel.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 24/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

@objc
class ListsViewModel: NSObject {
    
    private let database: SQLiteDatabase
    weak var delegate: ListsViewModelDelegate?
    
    @objc
    init(database: SQLiteDatabase){
        self.database = database
    }
}

extension ListsViewModel {

    func retrieveListNames() -> [String] {
        return self.database.listUserLists()
    }
    
    func getListCount(listName: String) -> Int {
        return self.database.getListRowsCount(listName: listName)
    }
    
    func addNewList(listName: String) {
        let result = database.insertNewList(listName: listName)
        
        if result {
            delegate?.updateTableView()
        }
    }
    
    func deleteList(listName: String) {
        self.database.deleteList(listName: listName)
    }

    func checkBasicList(listName: String) -> Bool{
        return self.database.BASIC_LISTS.contains(listName)
    }
}

protocol ListsViewModelDelegate: class {
    func updateTableView()
}

@objc
protocol ListsViewModelProvider: NSObjectProtocol {
    func listsViewModel() -> ListsViewModel
}
