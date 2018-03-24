//
//  AppDelegate.swift
//  FilmsBoard
//
//  Created by Pablo on 07/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let assembly = AppAssembly().activate()
        self.appCoordinator = assembly?.appCoordinator() as! AppCoordinator

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = self.appCoordinator.rootCoordinator
        window?.makeKeyAndVisible()
        
        
        
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        let acceptAction = UNNotificationAction(identifier: "ACCEPT",
                                                  title: "Aceptar",
                                                  options: [.destructive])
        
        
        let remindAction = UNNotificationAction(identifier: "REMIND",
                                                title: "Recordar más tarde",
                                                options: []) //Implement

        
        let movieCategory = UNNotificationCategory(identifier: "MOVIE_CATEGORY",
                                                  actions: [acceptAction],
                                                  intentIdentifiers: [],
                                                  options: [.customDismissAction])
        
        
        notificationCenter.setNotificationCategories([movieCategory])
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            //Parse errors and track state
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        switch (response.actionIdentifier) {
        case "ACCEPT":
            let database = SQLiteDatabase()
            database.deleteMediaFromList(listName: "Recordatorios", id_media: Int(response.notification.request.content.userInfo["movie_id"]! as! String)!, type: 0)
            
        case "REMIND":
            print("")
            //IMPLEMENT
        default: // switch statements must be exhaustive - this condition should never be met
            print("Error: unexpected notification action identifier!")
        }
        
        
        
        
        completionHandler()
    }
    


}

