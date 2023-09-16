//
//  CreateNewMessage.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 15/09/2023.
//

import Foundation
import SwiftUI

struct CreateNewMessageView: View {
    let didSelectChatUser : (ChatUser) ->  ()
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                    .onTapGesture {
                        print(vm.users)
                    }
                ForEach(vm.users) { user in
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            didSelectChatUser(user )
                        } label: {
                            HStack(spacing: 16) {
                                Text("alo")
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
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
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
