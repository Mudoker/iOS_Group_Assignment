//
//  Test+AddComment.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 13/09/2023.
//

import SwiftUI


struct Test_AddComment: View {
    @StateObject var uploadVM = UploadPostViewModel()
    var body: some View {
        Button(action: {
            Task {
                do {
                    // Create a comment with the required information
                    let comment = try await uploadVM.createComment(content: "Nice picture", commentor: "3WBgDcMgEQfodIbaXWTBHvtjYCl2")
                    
                    // Create a post
//                    let post = try await uploadVM.createPost(owner: "3WBgDcMgEQfodIbaXWTBHvtjYCl2", postCaption: "New Year", mediaURL: "", mimeType: "")
                    
                    // Add the comment to the post
                    if let comment = comment {
                        try await uploadVM.addCommentToPost(comment: comment , postID: "dvjaZmr2V8ojhlDXPfI1")
                    }
                } catch {
                    // Handle any errors that may occur during the operations
                    print("Error: \(error)")
                }
            }
        }) {
            Text("Add comment")
        }

    }
}

struct Test_AddComment_Previews: PreviewProvider {
    static var previews: some View {
        Test_AddComment()
    }
}
