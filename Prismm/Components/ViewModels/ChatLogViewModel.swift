//
//  ChatLogViewModel.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 21/09/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

class ChatLogViewModel : ObservableObject{
    
    @Published var chatText = ""
    @Published var isSeen = false
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessageModel]()
    
    var  chatUser: User?
    
    init(chatUser: User?) {
        self.chatUser = chatUser
        fetchMessages()
    }
    
    var firestoreListener : ListenerRegistration?
    
    func fetchMessages() {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = chatUser?.id else { return }
        
        firestoreListener?.remove()
        chatMessages.removeAll()
        
        firestoreListener = Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    
    func sendMessage(){
        print(chatText)
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        
        guard let toId = chatUser?.id else { return }
        
        
        let document = Firestore.firestore().collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = ["fromId": fromId, "toId": toId, "text": self.chatText, "timestamp": Timestamp(), "isSeen": false] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
            self.persistRecentMessage()
            self.chatText = ""
            self.isSeen = false
            self.count += 1
        }
        
        let recipientMessageDocument = Firestore.firestore().collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Recipient saved message as well")
        }
    }
    
    
    func updateIsSeen(forMessageWithID messageID: String){
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        
        guard let toId = chatUser?.id else { return }
        
        
        let document = Firestore.firestore().collection("messages")
            .document(fromId)
            .collection(toId)
            .document(messageID)
        
        let messageData = [FirebaseConstants.isSeen: true]
        
        document.updateData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
            self.persistRecentMessage()
            print()
            
            let recipientMessageDocument = Firestore.firestore().collection("messages")
                .document(toId)
                .collection(fromId)
                .document()
            
            recipientMessageDocument.setData(messageData) { error in
                if let error = error {
                    print(error)
                    self.errorMessage = "Failed to save message into Firestore: \(error)"
                    return
                }
                
                print("Recipient saved message as well")
            }
        }
    }
    
    private func persistRecentMessage() {
        guard let chatUser = chatUser else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let toId = self.chatUser?.id else { return }
        
        let document = Firestore.firestore()
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.email: chatUser.username,
            FirebaseConstants.isSeen : self.isSeen
        ] as [String : Any]
        
        // you'll need to save another very similar dictionary for the recipient of this message...how?
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = Auth.auth().currentUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.email: currentUser.email ?? "huuquoc7603@gmail.com",
            FirebaseConstants.isSeen : self.isSeen
        ] as [String : Any]
        
        Firestore.firestore()
            .collection("recent_messages")
            .document(toId)
            .collection("messages")
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    @Published var count = 0
}
