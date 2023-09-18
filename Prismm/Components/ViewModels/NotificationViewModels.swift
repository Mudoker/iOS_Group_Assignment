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
    @Published var fetched_noti = [Notification]()
    private var notiListenerRegistration: ListenerRegistration?

    func createNotification(senderName: String, receiver: String, message: String, category: NotificationCategory) async throws -> Notification? {
        let notiRef = Firestore.firestore().collection("test_noti").document()
        let noti = Notification(id: notiRef.documentID, senderName: senderName,receiver: receiver, message: message, time: Timestamp(), category: category)
        guard let encodedNoti = try? Firestore.Encoder().encode(noti) else {return nil}
        try await notiRef.setData(encodedNoti)
        print("ok")
        return noti
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

            self.fetched_noti = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Notification.self)
            }
        }
    }
}
