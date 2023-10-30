//
//  NotificationsManager.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 27/10/23.
//

import Foundation
import UserNotifications

class NotificationsManager: ObservableObject {
    private var notificationsDelegate: NotificationDelegate = NotificationDelegate()
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, _) in
        }
        UNUserNotificationCenter.current().delegate = notificationsDelegate
    }
    
    func createNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hooray!"
        content.subtitle = "You have saved your emotional weather! ⛅"
        let request = UNNotificationRequest(identifier: "IN-APP", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate  {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
}
