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

    func createNotification(senderName: String, receiver: String, message: String, postLink: String,category: NotificationCategory) async throws -> AppNotification? {
        let notificationRef = Firestore.firestore().collection("test_noti").document()
        let newNotification = AppNotification(id: notificationRef.documentID, senderName: senderName,receiverId: receiver, messageContent: message, postLink: postLink,creationDate: Timestamp(), category: category)
        guard let encodedNotification = try? Firestore.Encoder().encode(newNotification) else {return nil}
        try await notificationRef.setData(encodedNotification)
        print("ok")
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
