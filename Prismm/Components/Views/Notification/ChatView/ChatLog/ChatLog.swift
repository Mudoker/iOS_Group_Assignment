//
//  ChatLog.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 15/09/2023.
//

import Foundation

import SwiftUI
import Firebase

 
struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let email = "email"
    static let uid = "uid"
    static let profileImageUrl = "profileImageUrl"
    static let messages = "messages"
    static let users = "users"
    static let recentMessages = "recent_messages"
    static let isSeen = "isSeen"
}
 
struct ChatMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, text: String
    let isSeen : Bool
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.isSeen = data[FirebaseConstants.isSeen] as? Bool ?? false
    }
}
class ChatLogViewModel : ObservableObject{
    
    @Published var chatText = ""
    @Published var isSeen = false
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    
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
            FirebaseConstants.email: chatUser.gmail,
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
            FirebaseConstants.email: currentUser.email,
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

struct ChatLogView: View {
    static let emptyScollView = "Empty"
    
    @State var chatText = ""
//    let chatUser: ChatUser?
//    init(chatUser: ChatUser?) {
//        self.chatUser = chatUser
//        self.vm = .init(chatUser: chatUser)
//    }
    
    @ObservedObject var vm : ChatLogViewModel
    @State var isUserActive : Bool = true
    
    var body: some View {
        VStack {
            Spacer()
            ScrollView(showsIndicators: false) {
                ScrollViewReader{ scollViewProxy in
                    VStack {
                        ForEach(vm.chatMessages) { message in
                            MessageView(message: message)
                        }
                        
                        HStack{
                            Spacer()
                        }
                        .id(Self.emptyScollView)
                    }
                    .onReceive(vm.$count){ _ in
                        withAnimation(.easeOut(duration: 0.5)){
                            scollViewProxy.scrollTo(Self.emptyScollView, anchor: .bottom)
                        }
                    }
                    
                }
            }
            .padding(.leading,10)
            //            .background(Color(.init(white: 0.95, alpha: 1)))
            //            .background(.gray)
            HStack{
                VStack {
                    HStack {
                        HStack(spacing: 16) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 24))
                                .foregroundColor(Color(.darkGray))
                            ZStack {
                                DescriptionPlaceholder()
                                TextEditor(text: $vm.chatText)
                                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
                            }
                            .frame(height: 40)
                            Button{
                                vm.sendMessage()
                            } label: {
                                VStack{
                                    Image("message-icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                .frame(width: 25, height: 25)
                            }
                            
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        // need to re-consider
//                        HStack {
//                            Image(systemName: "mic")
//                                .foregroundColor(.gray)
//                            TextField("Type here", text: $vm.chatText)
//                                .foregroundColor(.black)
//                            Image(systemName: "photo.on.rectangle.angled")
//                                .foregroundColor(.gray)
//                            Image(systemName: "face.smiling")
//                                .foregroundColor(.gray)
//                        }
//                        .frame(height: 40)
//                        .padding(8)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal,10)
            }
            .padding(.top,10)
        }
        .onAppear {
            if let firstMessage = vm.chatMessages.first {
                vm.updateIsSeen(forMessageWithID: firstMessage.documentId)

            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                HStack{
                    Image("testAvt")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipped()
                        .cornerRadius(64)
                        .overlay(RoundedRectangle(cornerRadius: 64)
                            .stroke(Color.black, lineWidth: 1))
                        .shadow(radius: 5)
                    
                    VStack(alignment:.leading,spacing: 0){
                        Text("\(vm.chatUser?.gmail!.replacingOccurrences(of: "@gmail.com", with: "")  ?? "")")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        VStack{
                            HStack(){
                                VStack{
                                    Circle()
                                        .foregroundColor(isUserActive ? .green: .white)
                                        .frame(width: 10, height: 10)
                                }
                                .frame(width: 10, height:10,alignment: .bottomTrailing)
                                Text(isUserActive ? "Online" : "")
                            }
                        }
                    }
                }
            }
        }
//        .navigationTitle(vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "")  ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear{
            vm.firestoreListener?.remove()
        }
    }
}


private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

private struct MessageView : View{
    let message: ChatMessage
    var body: some View{
//        GeometryReader { geometry in
            VStack {
                if message.fromId == Auth.auth().currentUser?.uid {
                    HStack {
                        Spacer()
                        HStack{
                            Text(message.text)
                                .foregroundColor(.white)
                        }
                        .padding(10)
                        .background(.blue)
//                        .cornerRadius(20, corners: [.topLeft, .topRight,.bottomLeft])
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Image("testAvt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
    //                    .cornerRadius(10)
    //                    .clipShape(RoundedRectangle(cornerRadius: 10, corners: [.top, .topTrailing, .bottomTrailing]))
                        
                    
                    }
                    .padding(.horizontal)
                    .padding(.top,8)
                }
                else{
                   
                    HStack {
                        Image("testAvt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        HStack {
                            Text(message.text)
                                .foregroundColor(.black)
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.3))
//                        .cornerRadius(20, corners: [.topLeft, .topRight,.bottomRight])
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Spacer()
                    }
                }
            }
//            .frame(width: geometry.size.width)
//        }
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
//

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
