////
////  Test+Like+Unlike.swift
////  Prismm
////
////  Created by Nguyen Dinh Viet on 15/09/2023.
////
//
//import SwiftUI
//
//struct Test_Like_Unlike: View {
//    @StateObject var uploadVM = UploadPostViewModel()
//    var body: some View {
//        Button(action: {
//            Task {
//                do {
//                    try await uploadVM.unLikePost(likerID: "JTOgXoUSsedSZqNwmj8Zd83TX5P2", postID: "tV3gfUVsjk34eKWg7StR")
//                } catch {
//                    print("Error like post: \(error)")
//                    // Handle the error as needed (e.g., display an error message to the user)
//                }
//            }
//        }) {
//            Text("Like")
//        }
//    }
//}
//
//struct Test_Like_Unlike_Previews: PreviewProvider {
//    static var previews: some View {
//        Test_Like_Unlike()
//    }
//}
