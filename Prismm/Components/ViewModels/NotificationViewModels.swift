//
//  NotificationViewModels.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 18/09/2023.
// https://www.youtube.com/watch?v=LSU-QmeUXP0
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import FirebaseStorage
import MobileCoreServices
import AVFoundation
import FirebaseFirestoreSwift

class NotificationViewModel: ObservableObject {
    @Published var fetchedAllNotifications = [AppNotification]()
    var pushNotification = NotificationManager()
    private var notiListenerRegistration: ListenerRegistration?

    func createInAppNotification(senderName: String, receiverId: String, message: String, postLink: String, category: NotificationCategory, restrictedByList: [String], blockedByList: [String], blockedList: [String]) async throws -> AppNotification? {
        
        // Check if the current user is in the restricted, blocked, or block list of the receiver
        if restrictedByList.contains(receiverId) || blockedByList.contains(receiverId) || blockedList.contains(receiverId) {
            // Handle the situation here, e.g., log a message or return an error.
            print("Cannot send notification to \(receiverId) due to restrictions or blocks.")
            return nil
        }
        
        let notiRef = Firestore.firestore().collection("test_noti")
        
        // Query to check for existing notifications with the same senderName, messageContent, and postLink
        let duplicateQuery = notiRef
            .whereField("senderName", isEqualTo: senderName)
            .whereField("messageContent", isEqualTo: message)
            .whereField("postLink", isEqualTo: postLink)
        
        let duplicateSnapshot = try await duplicateQuery.getDocuments()
        
        if duplicateSnapshot.isEmpty {
            // No duplicates found, create a new notification
            let notificationRef = notiRef.document()
            let newNotification = AppNotification(id: notificationRef.documentID, senderName: senderName, receiverId: receiverId, messageContent: message, postLink: postLink, creationDate: Timestamp(), category: category, isNotified: false)
            
            guard let encodedNotification = try? Firestore.Encoder().encode(newNotification) else { return nil }
            
            try await notificationRef.setData(encodedNotification)
            return newNotification
        } else {
            // Duplicates found, do not create a new notification
            print("Notification duplicated.")
            return nil
        }
    }


    func fetchNotifcationRealTime(userId: String) {
        notiListenerRegistration = Firestore.firestore().collection("test_noti").whereField("receiver", isEqualTo: userId).addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching notifications: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.fetchedAllNotifications = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: AppNotification.self)
            }
        }
    }
    
    func createPushNotification() {
        let notiRef = Firestore.firestore().collection("test_noti")

        // Create a query to order by 'creationDate' in descending order and limit to one document
        let query = notiRef
            .whereField("isNotified", isEqualTo: false)
            .order(by: "creationDate", descending: true)
            .limit(to: 1)

        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents, !documents.isEmpty {
                    for (index, document) in documents.enumerated() {
                        let timeInterval = TimeInterval(index) * 0.2
                        let data = document.data()
                        
                        // Schedule the notification with an increased time interval
                        self.pushNotification.scheduleNotification(at: Date(), ofType: .time, withTimeInterval: timeInterval,titled: "Prismm", andBody: String("\(data["senderName"]) \(data["messageContent"])"))
                        
                        // Update the 'isNotified' field to true in Firestore
                        let documentRef = notiRef.document(document.documentID)
                        documentRef.updateData(["isNotified": true]) { (error) in
                            if let error = error {
                                print("Error updating isNotified: \(error)")
                            } else {
                                print("isNotified updated successfully")
                            }
                        }
                    }
                } else {
                    print("No documents found")
                }
            }
        }
    }
}
