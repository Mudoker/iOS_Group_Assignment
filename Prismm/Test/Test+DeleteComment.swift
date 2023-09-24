////
////  Test+DeleteComment.swift
////  Prismm
////
////  Created by Nguyen Dinh Viet on 14/09/2023.
////
//
import SwiftUI

struct Test_DeleteComment: View {
    @StateObject var homeVm = HomeViewModel()
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await homeVm.editCurrentComment(commentID: "U7WZiiedwFd7bwuLZq6u", newContent: "new content of the comment")
                } catch {
                    print("Error deleting comment: \(error)")
                    // Handle the error as needed (e.g., display an error message to the user)
                }
            }
        }) {
            Text("Delete comment")
        }
    }
}


struct Test_DeleteComment_Previews: PreviewProvider {
    static var previews: some View {
        Test_DeleteComment()
    }
}
