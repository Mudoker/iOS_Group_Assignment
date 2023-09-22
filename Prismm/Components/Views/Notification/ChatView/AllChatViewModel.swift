//
//  AllChatViewModel.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 13/09/2023.
//

import Foundation

import Firebase
import FirebaseFirestoreSwift
struct RecentMessage: Codable,Identifiable {
    @DocumentID var id : String?
    let text, email: String
    let fromId, toId: String
    let timestamp:  Date
    let isSeen : Bool
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}

class MainMessagesViewModel :  ObservableObject {
    @Published var errMessage = ""
    @Published var chatUser : User?
    
    @MainActor
    func setMessageData() async {
        do{
            chatUser = try await APIService.fetchCurrentUserData()
            fetchRecentMessages()
            print(recentMessages)
        }catch{
            print("failed")
        }
        
        
    }
    
    @Published var recentMessages = [RecentMessage]()
    private var firestoreListener : ListenerRegistration?
    
    func updateIsSeen(forMessageWithID messageID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore()
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(messageID)
            .updateData([FirebaseConstants.isSeen: true]) { error in
                if let error = error {
                    print(error)
                    self.errMessage = "Failed to save message into Firestore: \(error)"
                } else {
                    print("Successfully updated isSeen status for the message")
                }
            }
    }
    
    
    private func fetchRecentMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore()
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
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    //                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                    
                    do{
                        if let rm = try? change.document.data(as: RecentMessage.self ){
                            self.recentMessages.insert(rm, at: 0)
                            print(self.recentMessages[0].isSeen)
                        }
                    } catch{
                        print(error)
                    }
                })
            }
    }
}
