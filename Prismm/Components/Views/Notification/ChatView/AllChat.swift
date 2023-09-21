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
import Firebase

struct AllChat : View {
    @State var searchTerm : String = ""
    @State var searchState : Bool = true
    @State var selected : Int = 0
    @State var showChatLogVIew : Bool = false
    @State var isUserActive : Bool = true
    @ObservedObject var vm =  MainMessagesViewModel()
    private var chatLogViewModal = ChatLogViewModel(chatUser: nil)
    
    @EnvironmentObject var dataControllerVM : DataControllerViewModel
    var body: some View {
        NavigationStack{
            mainMessageScreen
            NavigationLink("",isActive: $showChatLogVIew){
                //                ChatLogView(chatUser: self.chatUser)
                ChatLogView(vm: chatLogViewModal)
            }
        }
    }
    
    @State var chatUser: User?
    
    var mainMessageScreen : some View{
        NavigationStack{
            GeometryReader { geometry in
                ScrollView(.vertical){
                    LazyVStack{
                        VStack (spacing: 10){
                            
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
                                    ForEach(vm.recentMessages) { recentMessage in
                                        VStack(alignment: .leading) {
                                            Button {
                                                Task{
                                                    let uid = Auth.auth().currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                                                    
                                                    self.chatUser = try await APIService.fetchUser(withUserID: uid)
                                                    
                                                    self.chatLogViewModal.chatUser = self.chatUser
                                                    self.chatLogViewModal.fetchMessages()
                                                    self.showChatLogVIew.toggle()
                                                    if let firstMessage = vm.recentMessages.first {
                                                        vm.updateIsSeen(forMessageWithID: firstMessage.id!)
                                                        
                                                    }
                                                }
                                                
                                                
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
                                                            Text(recentMessage.email.replacingOccurrences(of: "@gmail.com", with: ""))
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
                                    Text("Message (\(vm.recentMessages.count))")
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Text("Request (0)")
                                        .foregroundColor(.blue)
                                }
                                
                                // Message List
                                LazyVStack(spacing: 12){
                                    ForEach(vm.recentMessages) { recentMessage in
                                        VStack {
                                            Button {
                                                
                                                Task{
                                                    let uid = Auth.auth().currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                                                    
                                                    self.chatUser = try await APIService.fetchUser(withUserID: uid)
                                                    
                                                    self.chatLogViewModal.chatUser = self.chatUser
                                                    self.chatLogViewModal.fetchMessages()
                                                    self.showChatLogVIew.toggle()
                                                    if let firstMessage = vm.recentMessages.first {
                                                        vm.updateIsSeen(forMessageWithID: firstMessage.id!)
                                                        
                                                    }
                                                }
                                                
                                                
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
                                                        .overlay{
                                                            
                                                            HStack(alignment: .center){
                                                                Circle()
                                                                    .foregroundColor(isUserActive ? .green: .white)
                                                                    .frame(width: 20, height: 20)
                                                            }
                                                            .frame(width: 70, height:70,alignment: .bottomTrailing)
                                                        }
                                                    
                                                    
                                                    VStack(alignment: .leading, spacing: 8) {
                                                        HStack{
                                                            Text(recentMessage.email.replacingOccurrences(of: "@gmail.com", with: ""))
                                                                .font(.system(size: 16, weight: .bold))
                                                                .foregroundColor(Color(.label))
                                                            Spacer()
                                                            Text("\(recentMessage.timeAgo )")
                                                                .font(.system(size: 14, weight: .semibold))
                                                                .foregroundColor(recentMessage.isSeen ? Color(.darkGray) : Color(.label))
                                                        }
                                                        HStack{
                                                            if (recentMessage.fromId == Auth.auth().currentUser?.uid){
                                                                Text(recentMessage.text)
                                                                    .font(.system(size: 14))
                                                                    .foregroundColor(Color(.darkGray))
                                                                    .multilineTextAlignment(.leading)
                                                                
                                                            }
                                                            else{
                                                                Text(recentMessage.text)
                                                                    .font(.system(size: 14))
                                                                    .multilineTextAlignment(.leading)
                                                                    .fontWeight(recentMessage.isSeen ? .regular : .bold)
                                                                    .foregroundColor(recentMessage.isSeen ? Color(.darkGray): Color(.black))
                                                                Spacer()
                                                                if (!recentMessage.isSeen){
                                                                    Circle()
                                                                        .foregroundColor(.blue)
                                                                        .frame(width: 15, height: 15)
                                                                }
                                                            }
                                                            
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                            
                                            Divider()
                                                .padding(.vertical, 8)
                                                .padding(.horizontal,55)
                                                .padding(.leading,25)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        //                        .frame(width: geometry.size.width)
                        
                    }
                    .frame(maxWidth: .infinity)
                    //                    .padding(.horizontal,190)
                    
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack(spacing: 25){
                                //                                Button{
                                //
                                //                                } label : {
                                //                                    Image(systemName: "arrow.left")
                                //                                }
                                
                                HStack(spacing: 10){
                                    Text(dataControllerVM.currentUser!.username)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .onTapGesture {
                                            print(vm.recentMessages)
                                        }
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
        .onAppear{
            Task{
                await vm.setMessageData()
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
                print(user.id)
                self.showChatLogVIew = true
                self.chatUser = user
                self.chatLogViewModal.chatUser = user
                self.chatLogViewModal.fetchMessages ()
            })
        }
    }
    
    
    
}

//struct AllChat_Previews: PreviewProvider {
//    static var previews: some View {
//        AllChat()
//    }
//}



