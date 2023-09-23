////
////  Test+BlockUser.swift
////  Prismm
////
////  Created by Nguyen Dinh Viet on 21/09/2023.
////
//
//import SwiftUI
//
//struct Test_FollowUser: View {
//    @ObservedObject var homeVM = HomeViewModel()
//    var body: some View {
//        
//        VStack {
//            Button(action: {
//                Task {
//                    try await APIService.followOtherUser(forUserID: "abc")
//                }
//            }) {
//                Text("Follow user")
//            }
//            .padding(.vertical)
//            
//            Button(action: {
//                Task {
//                    try await homeVM.unFollowOtherUser(forUserID: "abc")
//                }
//            }) {
//                Text("Unfollow user")
//            }
//        }
//        
//    }
//}
//
//struct Test_FollowUser_Previews: PreviewProvider {
//    static var previews: some View {
//        Test_FollowUser()
//    }
//}
