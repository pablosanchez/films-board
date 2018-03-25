//
//  NotificationsManager.swift
//  FilmsBoard
//
//  Created by Pablo on 24/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import UserNotifications

@objc
class NotificationsManager: NSObject {

    enum NotificationActions: String {
        case accept = "accept"
        case remind = "remind"
    }

    private let CATEGORY_ID = "media-items-category"

    private let notificationCenter: UNUserNotificationCenter
    private let db: SQLiteDatabase

    @objc
    init(db: SQLiteDatabase) {
        self.notificationCenter = UNUserNotificationCenter.current()
        self.db = db
        super.init()
        self.notificationCenter.delegate = self
    }

    func registerNotificationCategories() {
        let acceptAction = UNNotificationAction(identifier: NotificationActions.accept.rawValue,
            title: "Aceptar", options: [.destructive])
        let remindAction = UNNotificationAction(identifier: NotificationActions.remind.rawValue,
            title: "Recordar más tarde", options: [])

        let category = UNNotificationCategory(identifier: self.CATEGORY_ID,
            actions: [acceptAction, remindAction], intentIdentifiers: [], options: [.customDismissAction])

        self.notificationCenter.setNotificationCategories([category])
        self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in

        }
    }
}

extension NotificationsManager {

    func scheduleNotification(id: Int, title: String, time: DateComponents) {
        let content = UNMutableNotificationContent()
        content.body = "¡¡La película \(title) ya está en los cines!!"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = self.CATEGORY_ID
        let userInfo = ["media_id": String(id), "media_title": title]
        content.userInfo = userInfo

        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)

        let request = UNNotificationRequest(identifier: String(id), content: content, trigger: trigger)
        self.notificationCenter.add(request, withCompletionHandler: nil)
    }

    func unscheduleNotification(withId id: Int) {
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [String(id)])
    }
}

extension NotificationsManager: UNUserNotificationCenterDelegate {

    // MARK: UNUserNotificationCenterDelegate methods

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let id = Int(response.notification.request.content.userInfo["media_id"] as! String) else {
            completionHandler()
            return
        }

        guard let title = response.notification.request.content.userInfo["media_title"] as? String else {
            completionHandler()
            return
        }

        switch (response.actionIdentifier) {
        case NotificationActions.accept.rawValue, UNNotificationDismissActionIdentifier:
            self.db.deleteMediaFromList(listName: "Recordatorios", id_media: id, type: MediaItemTypes.movies.rawValue)
        case NotificationActions.remind.rawValue:
            self.db.deleteMediaFromList(listName: "Recordatorios", id_media: id, type: MediaItemTypes.movies.rawValue)
            let calendar = Calendar.current
            let remindRelativeHours: Double = 9
            let dateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date(timeIntervalSinceNow: remindRelativeHours * 3600))
            self.scheduleNotification(id: id, title: title, time: dateComponents)
        default:
            print("Error: unexpected notification action identifier!")
        }

        completionHandler()
    }
}
