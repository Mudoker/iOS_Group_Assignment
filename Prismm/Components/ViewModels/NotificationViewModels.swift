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

    // A can not send noti to B if A is restricted or blocked by B. B cannot send to A if B blocks A
    func createInAppNotification(senderName: String, receiverId: String, message: String, postLink: String, category: NotificationCategory, currentUserID: String, restrictedByList: [String], blockedByList: [String], blockedList: [String]) async throws -> AppNotification? {
        // Check if the current user is in the restricted or blocked list of the receiver
        if restrictedByList.contains(receiverId) || blockedByList.contains(receiverId) || blockedList.contains(receiverId){
            return nil
        }
        
        let notificationRef = Firestore.firestore().collection("test_noti").document()
        let newNotification = AppNotification(id: notificationRef.documentID, senderName: senderName, receiverId: receiverId, messageContent: message, postLink: postLink, creationDate: Timestamp(), category: category, isNotified: false)
        
        guard let encodedNotification = try? Firestore.Encoder().encode(newNotification) else { return nil }
        
        try await notificationRef.setData(encodedNotification)
        return newNotification
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
        let notiRef = Firestore.firestore().collection("notifications")

        // Create a query to order by 'creationDate' in descending order and limit to one document
        let query = notiRef.order(by: "creationDate", descending: true).limit(to: 1)

        // Execute the query
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let document = querySnapshot?.documents.first {
                    // You have the most recent document here
                    let data = document.data()
                    self.pushNotification.scheduleNotification(at: Date(), ofType: .time, withTimeInterval: 1,titled: "Prismm", andBody: String("\(data["senderName"]) \(data["messageContent"])"))
                } else {
                    print("No documents found")
                }
            }
        }
    }
}
