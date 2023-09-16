////
////  Test+DeletePost.swift
////  Prismm
////
////  Created by Nguyen Dinh Viet on 14/09/2023.
////
//
////
////  Test+DeleteComment.swift
////  Prismm
////
////  Created by Nguyen Dinh Viet on 14/09/2023.
////
//
//import SwiftUI
//
//struct Test_DeletePost: View {
//    @StateObject var uploadVM = UploadPostViewModel()
//    var body: some View {
//        Button(action: {
//            Task {
//                do {
//                    try await uploadVM.deletePost(postID: "VxX42KVo65NUgguqKQKY")
//                } catch {
//                    print("Error deleting post: \(error)")
//                    // Handle the error as needed (e.g., display an error message to the user)
//                }
//            }
//        }) {
//            Text("Delete post")
//        }
//    }
//}
//
//
//struct Test_DeletePost_Previews: PreviewProvider {
//    static var previews: some View {
//        Test_DeletePost()
//    }
//}
