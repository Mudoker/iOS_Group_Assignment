//
//  Test+EditPost.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 15/09/2023.
//

import SwiftUI

struct Test_EditPost: View {
    @StateObject var uploadVM = UploadPostViewModel()
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await uploadVM.editPost(postID: "tV3gfUVsjk34eKWg7StR", postCaption: "Swift Lord", mediaURL: "https://firebasestorage.googleapis.com:443/v0/b/prismm-a02a4.appspot.com/o/media%2FE1C5F2BB-B70B-471F-8C97-BBF76616C532?alt=media&token=f20d7eb3-3983-46ee-b0f7-7916151a3c63", mimeType: "video/mp4")
                } catch {
                    print("Error deleting post: \(error)")
                    // Handle the error as needed (e.g., display an error message to the user)
                }
            }
        }) {
            Text("Edit post")
        }
    }
}


struct Test_EditPost_Previews: PreviewProvider {
    static var previews: some View {
        Test_EditPost()
    }
}
