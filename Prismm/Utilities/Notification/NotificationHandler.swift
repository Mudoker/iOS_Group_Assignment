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
import FirebaseAuth

class NotificationManager {
    // allow in-app notification
    var notificationDelegate = InAppNotificationDelegate()
    
    // Get permission from user
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification access granted!")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    // Schedule time for push notification
    func scheduleNotification(at scheduledDate: Date, withTimeInterval timeInterval: Double = 10, titled title: String, andBody body: String) {
        print("called")
        var notificationTrigger: UNNotificationTrigger?
        
        // Create a trigger with a delay
        notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        // Customize the notification content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = UNNotificationSound.default
        
        // Create the notification request
        let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: notificationTrigger)
        
        // Allow in-app notification
        UNUserNotificationCenter.current().add(notificationRequest)
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }
}

// Inapp notification
class InAppNotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // Handle notification presentation when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
