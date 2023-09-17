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
    @State var isUserActive : Bool = true
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
//                            Text("\(vm.chatUser?.uid ?? "" )")
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                TextField("Search message", text: $searchTerm)
                                    .foregroundColor(.black)
                                
                                Button(action: {
                                    
                                    withAnimation(.spring()) {
                                        
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                
                            }
                            .frame(width: geometry.size.width - 50, height: 25)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .opacity(searchState ? 1 : 0) // Toggle opacity based on searchState
                            
                            ScrollView(.horizontal){
                                LazyHStack(spacing: 3){
                                    //                                        NavigationLink(destination: Text("alo")){
                                    //                                            UserActiveChat()
                                    //                                                .padding(.horizontal,10)
                                    //                                        }
                                    //                                        UserActiveChat()
                                    //                                            .padding(.horizontal,10)
                                    //                                        UserActiveChat()
                                    //                                            .padding(.horizontal,10)
                                    //                                        UserActiveChat()
                                    //                                            .padding(.horizontal,10)
                                    //                                        UserActiveChat()
                                    //                                            .padding(.horizontal,10)
                                    //                                        UserActiveChat()
                                    //                                            .padding(.horizontal,10)
                                    //                                        UserActiveChat()
                                    //                                            .padding(.horizontal,10)
                                    //                                        UserActiveChat()
                                    //                                            .padding(.horizontal,10)
                                    ForEach(vm.recentMessages) { recentMessage in
                                        VStack(alignment: .leading) {
                                            Button {
                                                let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                                                
                                                self.chatUser = .init(data: [FirebaseConstants.email: recentMessage.email,FirebaseConstants.uid : uid])
                                                
                                                self.chatLogViewModal.chatUser = self.chatUser
                                                self.chatLogViewModal.fetchMessages()
                                                self.showChatLogVIew.toggle()
                                                
                                            } label: {
                                                HStack(spacing: 16) {
                                                    VStack{
                                                        Image("sample_avatar")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width : 80, height : 80)
                                                            .mask(Circle())
                                                            .overlay{
                                                                
                                                                HStack(alignment: .center){
                                                                    Circle()
                                                                        .foregroundColor(isUserActive ? .green: .white)
                                                                        .frame(width: 20, height: 20)
                                                                }
                                                                .frame(width: 80, height:75,alignment: .bottomTrailing)
                                                            }
                                                        VStack{
                                                            Text(recentMessage.email.replacingOccurrences(of: "@gmail.com", with: "")  ?? "")
                                                                .font(.system(size: 16, weight: .none))
                                                                .foregroundColor(Color(.label))
                                                        }
                                                        .frame(width: 80)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.trailing,20)
                                    }
                                }
                                .frame(height: 130)
                            }
                            
                            //Message
                            VStack(spacing: 15){
                                HStack{
//                                    Button{
//                                        self.selected = 0
//                                    } label: {
//                                        Text("Message")
//                                            .foregroundColor(.black)
//                                            .font(.footnote)
//                                            .frame(width: 70)
//                                            .padding(.vertical,12)
//                                            .padding(.horizontal,10)
//                                            .background(self.selected == 0 ? Color.blue : Color.white)
//                                            .clipShape(Capsule())
//                                    }
//
//                                    Button{
//                                        self.selected = 1
//                                    } label: {
//                                        Text("Request")
//                                            .foregroundColor(.black)
//                                            .font(.footnote)
//                                            .frame(width: 70)
//                                            .padding(.vertical,12)
//                                            .padding(.horizontal,10)
//                                            .background(self.selected == 1 ? Color.blue : Color.white)
//                                            .clipShape(Capsule())
//
//
//                                    }
                                    Text("Message (\(vm.recentMessages.count))")
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Text("Request (0)")
                                        .foregroundColor(.blue)
                                }
//                                .padding(8)
//                                .background(Color.gray.opacity(0.2))
//                                .clipShape(Capsule())
                                
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
                                    //                                        Text("Alo")
                                    //                                            .onTapGesture {
                                    //                                                print(vm.recentMessages)
                                    //                                            }
                                    ForEach(vm.recentMessages) { recentMessage in
                                        VStack {
                                            Button {
                                                let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                                                
                                                self.chatUser = .init(data: [FirebaseConstants.email: recentMessage.email,FirebaseConstants.uid : uid])
                                                
                                                self.chatLogViewModal.chatUser = self.chatUser
                                                self.chatLogViewModal.fetchMessages()
                                                self.showChatLogVIew.toggle()
                                                
                                            } label: {
                                                HStack(spacing: 16) {
                                                    Image("testAvt")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 64, height: 64)
                                                        .clipped()
                                                        .cornerRadius(64)
                                                        .overlay(RoundedRectangle(cornerRadius: 64)
                                                            .stroke(Color.black, lineWidth: 1))
                                                        .shadow(radius: 5)
                                                    
                                                    
                                                    VStack(alignment: .leading, spacing: 8) {
                                                        Text(recentMessage.email.replacingOccurrences(of: "@gmail.com", with: "")  ?? "")
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
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        //                    .offset(x: searchState ? -60 : 300, y: 70)
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal,190)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack(spacing: 25){
//                                Button{
//
//                                } label : {
//                                    Image(systemName: "arrow.left")
//                                }
                                
                                HStack(spacing: 10){
                                    Text("\(vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "")  ?? "")")
                                        .font(.title3)
                                        .fontWeight(.semibold)
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
                .padding(.horizontal,10)
            }
        }
    }
    @State var showNewMessageScreen = false
    var newMessageButton : some View{
        Button{
            showNewMessageScreen.toggle()
        } label : {
            Image(systemName: "pencil.line")
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



