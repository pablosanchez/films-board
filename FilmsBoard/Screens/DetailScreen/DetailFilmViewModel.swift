//
//  DetailFilmViewModel.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 20/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import UserNotifications


@objc class DetailFilmViewModel: NSObject {
    
    private let storage: MediaItemsStorage
    private let database: SQLiteDatabase
    private let dateUtils: DateUtils
    
    @objc init(storage: MediaItemsStorage, database: SQLiteDatabase, dateUtils: DateUtils)
    {
        self.storage = storage
        self.database = database
        self.dateUtils = dateUtils
    }
    
    
    
    func addFilmToList(listName: String) {
        self.database.insertMovieIntoList(listName: listName, movie: self.storage.currentIdMovieSelected!)
    }
    
    func deleteFromList(listName: String) {
        self.database.deleteMoviewFromList(listName: listName, id_movie: self.storage.currentIdMovieSelected!.id)
    }
    
    
    func retrieveListNames() -> [String] {
        return database.listUserLists()
    }
    
    
    func checkIfCanRemind() -> Bool{
        let actual = Date()
        
        if actual < self.dateUtils.getDateFromString(stringDate: self.storage.currentIdMovieSelected!.year)
        {
            return true
        }
        
        return false
    }
    
    func checkIfIsReminding() -> Bool {
        let result = self.database.checkMovieIsInList(listName: "Recordatorio", id_movie: self.storage.currentIdMovieSelected!.id)
        
        if result != 0 {
            return true
        }
        
        return false
    }
    
    
    func createReminder() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = "¡¡La película \(self.storage.currentIdMovieSelected!.title) ya está en los cines!!"
        notificationContent.sound = UNNotificationSound.default()
        notificationContent.categoryIdentifier = "MOVIE_CATEGORY"
        notificationContent.userInfo = ["movie_id" : String(self.storage.currentIdMovieSelected!.id)]
        
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: self.dateUtils.getDateFromString(stringDate: self.storage.currentIdMovieSelected!.year))
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: String(self.storage.currentIdMovieSelected!.id), content: notificationContent, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    func removeReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(self.storage.currentIdMovieSelected!.id)])
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
