//
//  Test+DeleteComment.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 14/09/2023.
//

import SwiftUI

struct Test_DeleteComment: View {
    @StateObject var uploadVM = UploadPostViewModel()
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await uploadVM.deleteComment(postID: "VxX42KVo65NUgguqKQKY", commentID: "gpEjxUQiY7WEdbXY1j1z")
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
