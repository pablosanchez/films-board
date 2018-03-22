//
//  SQLiteDatabase.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 22/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import SQLite


@objc class SQLiteDatabase: NSObject {
    
    private var database: Connection!
    
    private let table_movies = Table("movies")
    private let table_lists = Table("lists")
    
    
    private let id = Expression<Int>("id")
    
    private let posterImageURL = Expression<String>("posterImageULR")
    private let backgroundImageURL = Expression<String>("backgroundImageURL")
    private let title = Expression<String>("title")
    private let year = Expression<String>("year")
    private let overview = Expression<String>("overview")
    private let rating = Expression<Double>("rating")
    private let id_movie = Expression<Int>("id_movie")
    private let id_list = Expression<Int>("id_list")
    
    private let listName = Expression<String>("name")
    
    
    @objc override init() {
        super.init()
        self.initDatabase()
    }
    
    
    
    private func initDatabase() {
        self.getDatabase()
        self.createTableMovies()
        self.createTableLists()
        self.createBasicLists()
    }
    
    
    
    private func getDatabase(){
        do{
            let doc = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                  appropriateFor: nil, create: true)
            
            let fileURL = doc.appendingPathComponent("media_items").appendingPathExtension("sqlite3")
            
            let database = try Connection(fileURL.path)
            
            print(database)
            
            self.database = database
        } catch {
            print("ERROR 1: \(error)")
        }
    }
    
    
    private func createTableMovies(){
        let createTable = self.table_movies.create{(table) in
            table.column(self.id, primaryKey: true)
            table.column(self.id_movie)
            table.column(self.id_list)
            table.column(self.posterImageURL)
            table.column(self.backgroundImageURL)
            table.column(self.title)
            table.column(self.year)
            table.column(self.overview)
            table.column(self.rating)
            
            table.unique(self.id_movie, self.id_list)
            table.foreignKey(self.id_list, references: self.table_lists, self.id, delete: .cascade)
        }
        
        do {
            try self.database.run(createTable)
        } catch {
            print("ERROR: \(error)")
        }
        
    }
    
    
    
    private func createTableLists(){
        let createTable = self.table_lists.create{(table) in
            table.column(self.id, primaryKey: true)
            table.column(self.listName, unique: true)
        }
        
        do {
            try self.database.run(createTable)
        } catch {
            print("ERROR: \(error)")
        }
        
    }
    
    
    private func createBasicLists() {
        let query1 = self.table_lists.insert(self.listName <- "Favoritas")
        let query2 = self.table_lists.insert(self.listName <- "Pendientes")
        let query3 = self.table_lists.insert(self.listName <- "Vistas")
        
        do {
            try self.database.run(query1)
            try self.database.run(query2)
            try self.database.run(query3)
        } catch {
            print("\(error)")
        }
    }
    
}




extension SQLiteDatabase {
    
    func getListRowsCount(listName: String) -> Int {
        var rows: Int = 0
        
        let query = self.table_movies.join(self.table_lists,
                                           on: self.table_movies[self.id_list] == self.table_lists[self.id]).where(self.listName == listName)
        
        do {
            rows = try self.database.scalar(query.count)
        } catch {
            print("\(error)")
        }
        
        return rows
    }
    
    
    
    func listMoviesFromList(listName: String) -> [MediaItem] {
        var movies: [MediaItem] = []
        
        let query = self.table_movies.join(self.table_lists,
                                           on: self.table_movies[self.id_list] ==
                                            self.table_lists[self.id]).where(self.listName == listName)
        
        do {
            let result = try self.database.prepare(query)
            
            for movie in result {
                movies.append(self.fromRowToMediaItem(item: movie))
            }
        } catch {
            print("\(error)")
        }
        
        return movies
    }
    
    
    
    func getListId(listName: String) -> Int {
        var id: Int = 0
        
        let query = self.table_lists.select(self.id).where(self.listName == listName)
        
        do {
            let list = try self.database.prepare(query)
            
            for i in list {
                id = i[self.id]
            }
            
        } catch {
            print("\(error)")
        }
        
        return id
    }
    
    
    
    func insertMovieIntoList(listName: String, movie: MediaItem) {
        let listId = self.getListId(listName: listName)
        
        let query = self.table_movies.insert(self.id_movie <- movie.id,
                                             self.id_list <- listId,
                                             self.posterImageURL <- movie.posterImageURL,
                                             self.backgroundImageURL <- movie.backgroundImageURL,
                                             self.title <- movie.title,
                                             self.year <- movie.year,
                                             self.overview <- movie.description,
                                             self.rating <- Double(movie.rating))
        
        
        do {
            try self.database.run(query)
        } catch {
            print("\(error)")
        }
    }
    
    
    
    func listUserLists() -> [String] {
        var lists: [String] = []
        
        do {
            let result = try self.database.prepare(self.table_lists)
            
            for list in result {
                lists.append(list[self.listName])
            }
        } catch {
            print("\(error)")
        }
        
        return lists
    }
    
    
    func deleteMoviewFromList(listName: String, id_movie: Int) {
        let listId = self.getListId(listName: listName)
        
        
        do {
            let filter = self.table_movies.filter(self.id_movie == id_movie).filter(self.id_list == listId)
            
            try self.database.run(filter.delete())
        } catch {
            print("\(error)")
        }
    }
}


extension SQLiteDatabase {
    private func fromRowToMediaItem(item: Row) -> MediaItem {
        let posterImageURL = item[self.posterImageURL]
        let backgroundImageURL = item[self.backgroundImageURL]
        let title = item[self.title]
        let year = item[self.year]
        let overview = item[self.overview]
        let rating = item[self.rating]
        let id = item[self.id_movie]
        
        
        
        return Movie(posterImageURL: posterImageURL, backgroundImageURL: backgroundImageURL, title: title, year: year, description: overview, rating: Float(rating), id: id)
    }
}
