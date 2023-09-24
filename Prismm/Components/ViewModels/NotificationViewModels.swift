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
import FirebaseAuth

class NotificationViewModel: ObservableObject {
    // Users notifications
    @Published var fetchedAllNotifications = [AppNotification]()
    
    // Push notification
    var pushNotification = NotificationManager()
    
    // Fetch notification in real time
    private var notiListenerRegistration: ListenerRegistration?
    
    // create notification
    func createInAppNotification(senderId: String, receiverId: String, senderName: String, message: String, postId: String, category: NotificationCategory, blockedByList: [String], blockedList: [String]) async throws -> AppNotification? {
        
        let receiverResrictList = try await APIService.fetchUserRestrictedList(withUserId: receiverId)
        print(receiverResrictList?.restrictIds.count)
        if blockedByList.contains(receiverId) || blockedList.contains(receiverId) || receiverId == senderId || (((receiverResrictList?.restrictIds.contains(senderId)) == true)) {
            // Handle the situation here, e.g., log a message or return an error.
            print("Cannot send notification to \(receiverId) due to restrictions or blocks.")
            return nil
        }
        
        let notiRef = Firestore.firestore().collection("test_noti")
        
        // Query to check for existing notifications with the same senderName, messageContent, and postLink
        // Avoid user like a post -> unlike -> re-like a post (only create 1 noti)
        let duplicateQuery = notiRef
            .whereField("senderId", isEqualTo: senderId)
            .whereField("messageContent", isEqualTo: message)
            .whereField("postId", isEqualTo: postId)
            .whereField("receiverId", isEqualTo: receiverId)
        
        let duplicateSnapshot = try await duplicateQuery.getDocuments()
        
        if duplicateSnapshot.isEmpty {
            // No duplicates found, create a new notification
            let notificationRef = notiRef.document()
            let newNotification = AppNotification(id: notificationRef.documentID, senderId: senderId, receiverId: receiverId, messageContent: message, postId: postId, creationDate: Timestamp(), category: category, isNotified: false, senderName: senderName)
            
            // Save on firebase
            guard let encodedNotification = try? Firestore.Encoder().encode(newNotification) else { return nil }
            
            try await notificationRef.setData(encodedNotification)
            
            // After create on firebase, create a local push notification
//            createPushNotification()
            return newNotification
        } else {
            // Duplicates found, do not create a new notification
            print("Notification duplicated.")
            return nil
        }
    }
    
    // Fetch users noti in realtime
    func fetchNotifcationRealTime(userId: String) {
        notiListenerRegistration = Firestore.firestore().collection("test_noti").whereField("receiverId", isEqualTo: userId).addSnapshotListener { [weak self] querySnapshot, error in
            print(userId)
            guard let self = self else { return }
            
            // Error handling
            if let error = error {
                print("Error fetching notifications: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            // Returned notifications
            self.fetchedAllNotifications = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: AppNotification.self)
            }
            if (!self.fetchedAllNotifications.isEmpty) {
                createPushNotification()
            }
        }
    }
    
    // Create local push notification
    func createPushNotification() {
        let notiRef = Firestore.firestore().collection("test_noti")
        
        // Create a query to order by 'creationDate' in descending order (newest to oldest)
        let query = notiRef
            .order(by: "creationDate", descending: true)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return // Exit early on error
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No documents found")
                return // Exit if there are no documents
            }
            
            for (index, document) in documents.enumerated() {
                let data = document.data()
                
                // unwrap senderName and messageContent
                if let senderName = data["senderName"] as? String, let messageContent = data["messageContent"] as? String {
                    // Check if 'isNotified' is false
                    if let isNotified = data["isNotified"] as? Bool, !isNotified {
                        // Schedule the notification with an increased time interval (avoid notification conflict)
                        self.pushNotification.scheduleNotification(at: Date(), withTimeInterval: (Double(index) + 0.1), titled: "Prismm", andBody: "\(senderName) \(messageContent)")
                        
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
                    print("Invalid data in document \(document.documentID)")
                }
            }
        }
    }
}
