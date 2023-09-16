//
//  AllChatViewModel.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 13/09/2023.
//

import Foundation

import Firebase
import FirebaseFirestoreSwift
struct RecentMessage: Identifiable {
    
    var id: String { documentId }
    //    @DocumentID var id : String?
    let documentId: String
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Timestamp
    
    
    //    var username: String {
    //        email.components(separatedBy: "@").first ?? email
    //    }
    //
    //    var timeAgo: String {
    //        let formatter = RelativeDateTimeFormatter()
    //        formatter.unitsStyle = .abbreviated
    //        return formatter.localizedString(for: timestamp, relativeTo: Date())
    //    }
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.text = data["text"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}

class MainMessagesViewModel :  ObservableObject {
    @Published var errMessage = ""
    @Published var chatUser : ChatUser?
    init(){
        fetchCurrentUser()
        fetchRecentMessages()
    }
    @Published var recentMessages = [RecentMessage]()
    private var firestoreListener : ListenerRegistration?
    private func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.documentId == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                    
                    
//                    self.recentMessages.append()
                })
            }
    }
//    func fetchRecentMessages(){
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        firestoreListener?.remove()
//        firestoreListener = FirebaseManager.shared.firestore
//            .collection("recent_messages")
//            .document(uid)
//            .collection("messages")
//            .order(by: "timestamp")
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    self.errMessage = "Failed to listen for recent messages: \(error)"
//                    print(error)
//                    return
//                }
//
//                querySnapshot?.documentChanges.forEach({ change in
//                    let docId = change.document.documentID
//                    self.recentMessages.insert(.init(documentID : docId, data: change.document.data()), at: 0)
//                })
//                //                querySnapshot?.documentChanges.forEach({ change in
//                //                    let docId = change.document.documentID
//                //
//                //                    if let index = self.recentMessages.firstIndex(where: { rm in
//                //                        return rm.id == docId
//                //                    }) {
//                //                        self.recentMessages.remove(at: index)
//                //                    }
//                //
//                //                    do{
//                //                        if let rm = try? change.document.data(as: RecentMessage.self ){
//                //                            self.recentMessages.insert(rm, at: 0)
//                //                        }
//                //                    } catch{
//                //                        print(error)
//                //                    }
//                //                    //                    self.recentMessages.insert(.init(documentId : docId, data: change.document.data()), at: 0)
//                //
//                //
//                //                    //                    self.recentMessages.append()
//                //                })
//            }
//    }
    private func fetchCurrentUser(){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            self.errMessage = "Could not find the uid"
            return
        }
        
        self.errMessage = "\(uid)"
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument{ snapshot, err in
                if let err = err{
                    print("Fail to fetch current user", err)
                    return
                }
                
                guard let data = snapshot?.data() else{
                    return
                }
                print(data)
                // can refractor
                self.chatUser = .init(data: data)
            }
    }
}
