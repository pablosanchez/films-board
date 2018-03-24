//
//  DetailFilmViewModel.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 20/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import UserNotifications

@objc
class DetailFilmViewModel: NSObject {
    
    private let database: SQLiteDatabase
    private let mediaItem: MediaItem
    
    weak var delegate: TrailerButtonTappedDelegate?
    
    @objc
    init(storage: MediaItemsStorage, database: SQLiteDatabase) {
        self.database = database
        self.mediaItem = storage.currentMediaItemSelected
    }

    func addFilmToList(listName: String) {
        self.database.insertMovieIntoList(listName: listName, movie: self.mediaItem)
    }
    
    func deleteFromList(listName: String) {
        self.database.deleteMoviewFromList(listName: listName, id_movie: self.mediaItem.id)
    }

    func retrieveListNames() -> [String] {
        return database.listUserLists()
    }

    func checkIfCanRemind() -> Bool {
        let now = Date()

        return now < self.mediaItem.releaseDate.toDate() ?? now
    }
    
    func checkIfIsReminding() -> Bool {
        let result = self.database.checkMovieIsInList(listName: "Recordatorios", id_movie: self.mediaItem.id)
        
        if result != 0 {
            return true
        }
        
        return false
    }
    
    func createReminder() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = "¡¡La película \(self.mediaItem.title) ya está en los cines!!"
        notificationContent.sound = UNNotificationSound.default()
        notificationContent.categoryIdentifier = "MOVIE_CATEGORY"
        notificationContent.userInfo = ["movie_id": String(self.mediaItem.id)]

        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: self.mediaItem.releaseDate.toDate() ?? Date())
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: String(self.mediaItem.id), content: notificationContent, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func removeReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(self.mediaItem.id)])
    }

    func watchTrailer() {
        delegate?.trailerButtonTapped()
    }

    var mainImage: String {
        return self.mediaItem.posterImageURL
    }
    
    var backImage: String {
        return self.mediaItem.backgroundImageURL
    }
    
    var title: String {
        return self.mediaItem.title
    }
    
    var year: String {
        return self.mediaItem.releaseDate
    }
    
    var overview: String {
        return self.mediaItem.description
    }
    
    var rating: Double {
        return self.mediaItem.rating
    }
}
protocol TrailerButtonTappedDelegate: class {
    func trailerButtonTapped()
}

@objc protocol DetailFilmViewModelProvider: NSObjectProtocol {
    func detailFilmViewModel() -> DetailFilmViewModel
}
