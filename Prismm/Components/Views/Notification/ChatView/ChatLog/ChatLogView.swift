//
//  ChatLog.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 15/09/2023.
//

import Foundation

import SwiftUI
import Firebase

 

struct ChatLogView: View {
    static let emptyScollView = "Empty"
    
    @State var chatText = ""

    
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
                        Text("\(vm.chatUser?.account!.replacingOccurrences(of: "@gmail.com", with: "")  ?? "")")
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
        .toolbar(.hidden, for: .tabBar)
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
    let message: ChatMessageModel
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
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Image("testAvt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())

                        
                    
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
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Spacer()
                    }
                }
            }
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
