//
//  CreateNewMessage.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 15/09/2023.
//

import Foundation
import SwiftUI

struct CreateNewMessageView: View {
    
    @State var searchTerm : String = ""
    @State var searchState : Bool = true
    let didSelectChatUser : (ChatUser) ->  ()
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    //                Text(vm.errorMessage)
                    //                    .onTapGesture {
                    //                        print(vm.users)
                    //                    }
                    
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
                    .opacity(searchState ? 1 : 0)
                    .padding(.top,15)
                    
                    HStack{
                        Image(systemName: "person.fill")
                            .scaleEffect(1.4)
                        Text("Individual chat")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.leading,20)
                    .padding(.vertical,20)
                    
                    HStack{
                        Text("Suggested")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.leading,20)
                    .padding(.vertical,20)
                    
                    ForEach(vm.users.filter { user in
                        searchTerm.isEmpty || user.email.localizedCaseInsensitiveContains(searchTerm)
                    },id: \.id) { user in
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            didSelectChatUser(user)
                        } label: {
                            HStack(spacing: 16) {
                                Image("testAvt")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(50)
                                    .overlay(RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color(.label), lineWidth: 2)
                                    )
                                Text(user.email)
                                    .foregroundColor(Color(.label))
                                Spacer()
                            }.padding(.horizontal)
                            
                        }
                        Divider()
                            .padding(.vertical, 8)
                            .padding(.horizontal,55)
                            .padding(.leading,25)
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Text("CreateNew Message")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

struct CreateNewMessage_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageView(didSelectChatUser: { user in
            print(user.email)
        })
    }
}
