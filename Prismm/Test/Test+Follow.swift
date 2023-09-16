////
////  Test+Follow.swift
////  Prismm
////
////  Created by Nguyen Dinh Viet on 14/09/2023.
////
//
//import SwiftUI
//
//struct Test_Follow: View {
//    @StateObject var uploadVM = UploadPostViewModel()
//    var body: some View {
//        Button(action: {
//            Task {
//                do {
//                    try await uploadVM.unFollowOtherUser(userID: "58Dcdq2lanhAHaRn5AbIKTqfSvs2")
//                } catch {
//                    print("Error following user: \(error)")
//                    // Handle the error as needed (e.g., display an error message to the user)
//                }
//            }
//        }) {
//            Text("Follow")
//        }
//    }
//}
//
//struct Test_Follow_Previews: PreviewProvider {
//    static var previews: some View {
//        Test_Follow()
//    }
//}
