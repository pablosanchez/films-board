//
//  SQLiteDatabase.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 22/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import SQLite

@objc
class SQLiteDatabase: NSObject {
    
    private var database: Connection!
    
    private let table_media = Table("media")
    private let table_lists = Table("lists")

    private let id = Expression<Int>("id")
    
    private let posterImageURL = Expression<String>("posterImageULR")
    private let backgroundImageURL = Expression<String>("backgroundImageURL")
    private let title = Expression<String>("title")
    private let releaseDate = Expression<String>("year")
    private let overview = Expression<String>("overview")
    private let rating = Expression<Double>("rating")
    private let id_media = Expression<Int>("id_movie")
    private let id_list = Expression<Int>("id_list")
    private let type = Expression<Int>("type")
    
    private let listName = Expression<String>("name")

    let BASIC_LISTS = ["Favoritas", "Pendientes", "Vistas", "Recordatorios"]

    @objc
    override init() {
        super.init()
        self.initDatabase()
    }

    private func initDatabase() {
        self.getDatabase()
        self.createTableMovies()
        self.createTableLists()
        self.createBasicLists()
    }

    private func getDatabase() {
        do {
            let doc = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                  appropriateFor: nil, create: true)
            
            let fileURL = doc.appendingPathComponent("media_items").appendingPathExtension("sqlite3")
            
            let database = try Connection(fileURL.path)
            try database.execute("PRAGMA foreign_keys = ON;")
            
            self.database = database
        } catch { }
    }

    private func createTableMovies() {
        let createTable = self.table_media.create{(table) in
            table.column(self.id, primaryKey: true)
            table.column(self.id_media)
            table.column(self.id_list)
            table.column(self.posterImageURL)
            table.column(self.backgroundImageURL)
            table.column(self.title)
            table.column(self.releaseDate)
            table.column(self.overview)
            table.column(self.rating)
            table.column(self.type)
            
            table.unique(self.id_media, self.id_list, self.type)
            table.foreignKey(self.id_list, references: self.table_lists, self.id, delete: .cascade)
        }
        
        do {
            try self.database.run(createTable)
        } catch { }
    }

    private func createTableLists() {
        let createTable = self.table_lists.create{(table) in
            table.column(self.id, primaryKey: true)
            table.column(self.listName, unique: true)
        }
        
        do {
            try self.database.run(createTable)
        } catch { }
    }
    
    private func createBasicLists() {
        let query1 = self.table_lists.insert(self.listName <- BASIC_LISTS[0])
        let query2 = self.table_lists.insert(self.listName <- BASIC_LISTS[1])
        let query3 = self.table_lists.insert(self.listName <- BASIC_LISTS[2])
        let query4 = self.table_lists.insert(self.listName <- BASIC_LISTS[3])
        
        do {
            try self.database.run(query1)
        } catch { }
        
        do {
            try self.database.run(query2)
        } catch { }
        
        do {
            try self.database.run(query3)
        } catch { }
        
        do {
            try self.database.run(query4)
        } catch { }
    }
}

extension SQLiteDatabase {
    
    func getListRowsCount(listName: String) -> Int {
        var rows: Int = 0
        
        let query = self.table_media.join(self.table_lists,
                                           on: self.table_media[self.id_list] == self.table_lists[self.id]).where(self.listName == listName)
        
        do {
            rows = try self.database.scalar(query.count)
        } catch { }
        
        return rows
    }
    
    func listMediaFromList(listName: String, type: Int) -> [MediaItem] {
        var mediaItems: [MediaItem] = []
        
        let query = self.table_media.join(self.table_lists,
                                           on: self.table_media[self.id_list] ==
                                            self.table_lists[self.id]).where(self.listName == listName).where(self.type == type)
        
        do {
            let result = try self.database.prepare(query)
            
            for mediaItem in result {
                mediaItems.append(self.fromRowToMediaItem(item: mediaItem))
            }
        } catch { }
        
        return mediaItems
    }
    
    func getListId(listName: String) -> Int {
        var id: Int = 0
        
        let query = self.table_lists.select(self.id).where(self.listName == listName)
        
        do {
            let list = try self.database.prepare(query)
            
            for i in list {
                id = i[self.id]
            }
            
        } catch { }
        
        return id
    }

    func insertMediaIntoList(listName: String, media: MediaItem) {
        let listId = self.getListId(listName: listName)
        
        let query = self.table_media.insert(self.id_media <- media.id,
                                             self.id_list <- listId,
                                             self.posterImageURL <- media.posterImageURL,
                                             self.backgroundImageURL <- media.backgroundImageURL,
                                             self.title <- media.title,
                                             self.releaseDate <- media.releaseDate,
                                             self.overview <- media.description,
                                             self.rating <- Double(media.rating),
                                             self.type <- media.type.rawValue)
        
        
        do {
            try self.database.run(query)
        } catch { }
    }
    
    func listUserLists() -> [String] {
        var lists: [String] = []
        
        do {
            let result = try self.database.prepare(self.table_lists)
            
            for list in result {
                lists.append(list[self.listName])
            }
        } catch { }
        
        return lists
    }

    func deleteMediaFromList(listName: String, id_media: Int, type: Int) {
        let listId = self.getListId(listName: listName)
        
        do {
            let filter = self.table_media.filter(self.id_media == id_media).filter(self.id_list == listId).filter(self.type == type)
            
            try self.database.run(filter.delete())
        } catch { }
    }

    func checkMediaIsInList(listName: String, id_media: Int, type: Int) -> Int{
        var isInside: Int = 0
        let listId = self.getListId(listName: listName)
        
        let query = self.table_media.where(self.id_list == listId).where(self.id_media == id_media).where(self.type == type)
        
        do {
            isInside = try self.database.scalar(query.count)
        } catch { }
        
        return isInside
    }
    
    func insertNewList(listName: String) -> Bool {
        let query1 = self.table_lists.insert(self.listName <- listName)
        
        do {
            try self.database.run(query1)
            return true
        } catch { }
        
        return false
    }
    
    func deleteList(listName: String) {
        let listId = self.getListId(listName: listName)
        
        do {
            let filter = self.table_lists.filter(self.id == listId)
            
            try self.database.run(filter.delete())
        } catch { }
    }
}

extension SQLiteDatabase {

    private func fromRowToMediaItem(item: Row) -> MediaItem {
        let posterImageURL = item[self.posterImageURL]
        let backgroundImageURL = item[self.backgroundImageURL]
        let title = item[self.title]
        let releaseDate = item[self.releaseDate]
        let overview = item[self.overview]
        let rating = item[self.rating]
        let id = item[self.id_media]
        
        if item[self.type] == 0 {
            return Movie(id: id, posterImageURL: posterImageURL, backgroundImageURL: backgroundImageURL, title: title, description: overview, releaseDate: releaseDate, rating: rating)
        } else {
            return TvShow(id: id, posterImageURL: posterImageURL, backgroundImageURL: backgroundImageURL, title: title, description: overview, releaseDate: releaseDate, rating: rating)
        }
    }
}
