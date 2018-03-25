//
//  DetailFilmViewModel.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 20/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

@objc
class DetailFilmViewModel: NSObject {

    private let storage: MediaItemsStorage
    private let db: SQLiteDatabase
    private let notificationsManager: NotificationsManager
    private let apiManager: MoviesAPIManager

    private var mediaItem: MediaItem

    weak var delegate: DetailFilmViewModelDelegate?
    weak var routingDelegate: DetailFilmViewModelRoutingDelegate?

    @objc
    init(storage: MediaItemsStorage, db: SQLiteDatabase, apiManagerProvider: MoviesAPIManagerProvider, notificationsManager: NotificationsManager) {
        self.storage = storage
        self.db = db
        self.apiManager = apiManagerProvider.moviesAPIManager()
        self.notificationsManager = notificationsManager
        self.mediaItem = self.storage.currentMediaItemSelected
    }

    func addFilmToList(listName: String) {
        self.db.insertMediaIntoList(listName: listName, media: self.mediaItem)
    }
    
    func deleteFromList(listName: String) {
        self.db.deleteMediaFromList(listName: listName, id_media: self.mediaItem.id, type: self.mediaItem.type.rawValue)
    }

    func retrieveListNames() -> [String] {
        return db.listUserLists()
    }

    // A reminder can only be added for future movies
    func checkIfCanRemind() -> Bool {
        let now = Date()

        return now < self.mediaItem.releaseDate.toDate() ?? now
    }
    
    func checkIfIsReminding() -> Bool {
        let result = self.db.checkMediaIsInList(listName: "Recordatorios", id_media: self.mediaItem.id, type: self.mediaItem.type.rawValue)
        
        if result != 0 {
            return true
        }
        
        return false
    }
    
    func createReminder() {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: self.mediaItem.releaseDate.toDate() ?? Date())
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        self.notificationsManager.scheduleNotification(id: self.mediaItem.id, title: self.mediaItem.title, time: dateComponents)
    }

    func removeReminder() {
        self.notificationsManager.removeNotification(withId: self.mediaItem.id)
    }

    func watchTrailer() {
        routingDelegate?.detailFilmViewModelDidTapTrailerButton()
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
    
    var releaseDate: String {
        return self.mediaItem.releaseDate
    }
    
    var overview: String {
        return self.mediaItem.description
    }
    
    var rating: Double {
        return self.mediaItem.rating
    }

    var genres: String {
        return self.mediaItem.genres?.joined(separator: ", ") ?? ""
    }
}

extension DetailFilmViewModel {

    func getDetails() {
        self.apiManager.getMediaItemData(id: self.mediaItem.id, type: self.mediaItem.type) { [unowned self] (error) in
            guard error == nil else {
                var errorMsg = ""
                if let error = error as? HTTPRequestError {
                    errorMsg = error.message
                } else if let error = error as? MediaItemsBuilderError {
                    errorMsg = error.errorMessage
                } else {
                    errorMsg = "Error desconocido"
                }

                self.delegate?.detailFilmViewModel(self, didGetError: errorMsg)
                return
            }

            self.mediaItem = self.storage.currentMediaItemSelected  // Update media item selected
            self.delegate?.detailFilmViewModelDidUpdateData(self)
        }
    }
}

protocol DetailFilmViewModelDelegate: class {
    func detailFilmViewModelDidUpdateData(_ viewModel: DetailFilmViewModel)
    func detailFilmViewModel(_ viewModel: DetailFilmViewModel, didGetError error: String)
}

protocol DetailFilmViewModelRoutingDelegate: class {
    func detailFilmViewModelDidTapTrailerButton()
}

@objc protocol DetailFilmViewModelProvider: NSObjectProtocol {
    func detailFilmViewModel() -> DetailFilmViewModel
}
