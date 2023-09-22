//
//  Test+BlockUser.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 21/09/2023.
//

import SwiftUI

struct Test_RestrictUser: View {
    @ObservedObject var homeVM = HomeViewModel()
    var body: some View {
        
        VStack {
            Button(action: {
                Task {
                    try await homeVM.restrictOtherUser(forUserID: "kkk")
                }
            }) {
                Text("Restrict user")
            }
            .padding(.vertical)
            
            Button(action: {
                Task {
                    try await homeVM.unRestrictOtherUser(forUserID: "abc")
                }
            }) {
                Text("Unrestrict user")
            }
        }
        
    }
}

struct Test_RestrictUser_Previews: PreviewProvider {
    static var previews: some View {
        Test_RestrictUser()
    }
}
