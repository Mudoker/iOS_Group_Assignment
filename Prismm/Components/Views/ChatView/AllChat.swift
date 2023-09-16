//
//  AllChat.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 08/09/2023.
//

import Foundation
//
//  SplashScreen.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 08/09/2023.
//

import Foundation
import SwiftUI

struct AllChat : View {
    @State var searchTerm : String = ""
    @State var searchState : Bool = true
    @State var selected : Int = 0
    @State var showChatLogVIew : Bool = false
    @ObservedObject var vm =  MainMessagesViewModel()
    private var chatLogViewModal = ChatLogViewModel(chatUser: nil)
    var body: some View {
        NavigationStack{
            mainMessageScreen
            NavigationLink("",isActive: $showChatLogVIew){
//                ChatLogView(chatUser: self.chatUser)
                ChatLogView(vm: chatLogViewModal)
            }
        }
    }
    
    
    var mainMessageScreen : some View{
        NavigationStack{
                GeometryReader { geometry in
                    ScrollView(.vertical){
                        LazyVStack{
                            VStack (spacing: 10){
                                Text("\(vm.chatUser?.uid ?? "" )")
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    TextField("Search", text: $searchTerm)
                                        .foregroundColor(.black)
                                    
                                    Button(action: {
                                        
                                        withAnimation(.spring()) {
                                            
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    
                                }
                                .frame(width: geometry.size.width - 35, height: 25)
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .opacity(searchState ? 1 : 0) // Toggle opacity based on searchState
                                
                                ScrollView(.horizontal){
                                    LazyHStack{
                                        NavigationLink(destination: Text("alo")){
                                            UserActiveChat()
                                                .padding(.horizontal,10)
                                        }
                                        UserActiveChat()
                                            .padding(.horizontal,10)
                                        UserActiveChat()
                                            .padding(.horizontal,10)
                                        UserActiveChat()
                                            .padding(.horizontal,10)
                                        UserActiveChat()
                                            .padding(.horizontal,10)
                                        UserActiveChat()
                                            .padding(.horizontal,10)
                                        UserActiveChat()
                                            .padding(.horizontal,10)
                                        UserActiveChat()
                                            .padding(.horizontal,10)
                                    }
                                    .frame(height: 130)
                                }
                                
                                //Message
                                VStack(spacing: 15){
                                    HStack{
                                        Button{
                                            self.selected = 0
                                        } label: {
                                            Text("Message")
                                                .foregroundColor(.black)
                                                .font(.footnote)
                                                .frame(width: 70)
                                                .padding(.vertical,12)
                                                .padding(.horizontal,10)
                                                .background(self.selected == 0 ? Color.blue : Color.white)
                                                .clipShape(Capsule())
                                        }
                                        
                                        Button{
                                            self.selected = 1
                                        } label: {
                                            Text("Request")
                                                .foregroundColor(.black)
                                                .font(.footnote)
                                                .frame(width: 70)
                                                .padding(.vertical,12)
                                                .padding(.horizontal,10)
                                                .background(self.selected == 1 ? Color.blue : Color.white)
                                                .clipShape(Capsule())
                                            
                                            
                                        }
                                    }
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Capsule())
                                    
                                    // Message List
                                    LazyVStack(spacing: 12){
//                                        NavigationLink(destination: ChatLogView(chatUser: self.chatUser)){
//                                            PreviewUserChat()
//                                        }
//                                        PreviewUserChat()
//                                        PreviewUserChat()
//                                        PreviewUserChat()
//                                        PreviewUserChat()
//                                        PreviewUserChat()
//                                        PreviewUserChat()
//                                        PreviewUserChat()
//                                        PreviewUserChat()
                                        Text("Alo")
                                            .onTapGesture {
                                                print(vm.recentMessages)
                                            }
                                        ForEach(vm.recentMessages) { recentMessage in
                                            VStack {
                                                Text("alo")
                                                    .onTapGesture {
                                                        print(recentMessage)
                                                    }
                                                Button {
                                                    let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                                                    
                                                    self.chatUser = .init(data: [FirebaseConstants.email: recentMessage.email,FirebaseConstants.uid : uid])
                                                    
                                                    self.chatLogViewModal.chatUser = self.chatUser
                                                    self.chatLogViewModal.fetchMessages()
                                                    self.showChatLogVIew.toggle()
                                                } label: {
                                                    HStack(spacing: 16) {
                                                       Image("testAvt ")
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 64, height: 64)
                                                            .clipped()
                                                            .cornerRadius(64)
                                                            .overlay(RoundedRectangle(cornerRadius: 64)
                                                                        .stroke(Color.black, lineWidth: 1))
                                                            .shadow(radius: 5)
                                                        
                                                        
                                                        VStack(alignment: .leading, spacing: 8) {
                                                            Text(recentMessage.email)
                                                                .font(.system(size: 16, weight: .bold))
                                                                .foregroundColor(Color(.label))
                                                            Text(recentMessage.text)
                                                                .font(.system(size: 14))
                                                                .foregroundColor(Color(.darkGray))
                                                                .multilineTextAlignment(.leading)
                                                        }
                                                        Spacer()
                                                        
                                                        Text("\(recentMessage.timestamp.description )")
                                                            .font(.system(size: 14, weight: .semibold))
                                                            .foregroundColor(Color(.label))
                                                    }
                                                }

                                                
                                                Divider()
                                                    .padding(.vertical, 8)
                                            }.padding(.horizontal)
                                            
                                        }.padding(.bottom, 50)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            //                    .offset(x: searchState ? -60 : 300, y: 70)
                            
                            
                        }
                        .padding(.horizontal,190)
                        .toolbar{
                            ToolbarItem(placement: .navigationBarLeading) {
                                HStack(spacing: 25){
                                    Button{
                                        
                                    } label : {
                                        Image(systemName: "arrow.left")
                                    }
                                    HStack(spacing: 10){
                                        Text("\(vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "")  ?? "")")
                                        VStack{
                                            Image(systemName: "chevron.down")
                                                .scaleEffect(0.6)
                                        }
                                        .frame(width: 5, height: 5)
                                        
                                    }
                                }
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                HStack(spacing: 25){
                                    newMessageButton
                                }
                            }
                        }
                    }
                }
        }
    }
    @State var showNewMessageScreen = false
    var newMessageButton : some View{
        Button{
            showNewMessageScreen.toggle()
        } label : {
            Image(systemName: "plus.app")
                .foregroundColor(.black)
        }
        .fullScreenCover(isPresented: $showNewMessageScreen){
            CreateNewMessageView(didSelectChatUser: { user in
                print(user.email)
                self.showChatLogVIew = true
                self.chatUser = user
                self.chatLogViewModal.chatUser = user
                self.chatLogViewModal.fetchMessages () 
            })
        }
    }
    
    @State var chatUser: ChatUser?
}

struct AllChat_Previews: PreviewProvider {
    static var previews: some View {
        AllChat()
    }
}


