//
//  NotificationViewModels.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 18/09/2023.
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
    private var notiListenerRegistration: ListenerRegistration?

    // A can not send noti to B if A is restricted or blocked by B. B cannot send to A if B blocks A
    func createNotification(senderName: String, receiverId: String, message: String, postLink: String, category: NotificationCategory, currentUserID: String, restrictedByList: [String], blockedByList: [String], blockedList: [String]) async throws -> AppNotification? {
        // Check if the current user is in the restricted or blocked list of the receiver
        if restrictedByList.contains(receiverId) || blockedByList.contains(receiverId) || blockedList.contains(receiverId){
            return nil
        }
        
        let notificationRef = Firestore.firestore().collection("test_noti").document()
        let newNotification = AppNotification(id: notificationRef.documentID, senderName: senderName, receiverId: receiverId, messageContent: message, postLink: postLink, creationDate: Timestamp(), category: category)
        
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
}
