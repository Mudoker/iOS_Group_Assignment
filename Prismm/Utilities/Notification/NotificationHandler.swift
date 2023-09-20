//
//  NotificationHandler.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 20/09/2023.
//

import Foundation
import UserNotifications

import Foundation
import UserNotifications

class NotificationManager {
    var notificationDelegate = InAppNotificationDelegate()
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification access granted!")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(at scheduledDate: Date, ofType type: NotificationType, withTimeInterval timeInterval: Double = 10, titled title: String, andBody body: String) {
        var notificationTrigger: UNNotificationTrigger?
        
        // Create a trigger (either date-based or time-based)
        switch type {
        case .date:
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: scheduledDate)
            notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        case .time:
            notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }
        
        // Customize the notification content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = UNNotificationSound.default
        
        // Create the notification request
        let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(notificationRequest)
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }
}

enum NotificationType {
    case date
    case time
}

class InAppNotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // Handle notification presentation when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
