//
//  Test+BlockUser.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 21/09/2023.
//

import SwiftUI

struct Test_BlockUser: View {
    @ObservedObject var homeVM = HomeViewModel()
    var body: some View {
        
        VStack {
            Button(action: {
                Task {
                    try await homeVM.blockOtherUser(forUserID: "abc")
                }
            }) {
                Text("Block user")
            }
            .padding(.vertical)
            
            Button(action: {
                Task {
                    try await homeVM.unblockOtherUser(forUserID: "abc")
                }
            }) {
                Text("Unblock user")
            }
        }
        
    }
}

struct Test_BlockUser_Previews: PreviewProvider {
    static var previews: some View {
        Test_BlockUser()
    }
}
