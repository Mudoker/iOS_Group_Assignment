//
//  UploadPostViewModel.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 12/09/2023.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import FirebaseStorage
import MobileCoreServices
import AVFoundation
import FirebaseFirestoreSwift

class UploadPostViewModel: ObservableObject {
    //@Published var fetched_media = [Media]()
    @Published var fetched_post = [Post]()

    @Published var selectedMedia: PhotosPickerItem? {
        didSet {
            Task {
                try await uploadingPost()
            }
        }
    }
    
    init() {
        Task {
            try await fetchPost()
        }
    }
    
    @Published var postImage: Image?
    @Published var selectedVideoURL: URL? // Store the video URL

//    func uploadMediaFromLocal() async throws {
//        guard let media = selectedMedia else { return }
//
//        guard let mediaData = try await media.loadTransferable(type: Data.self) else { return }
//
//        if mediaData.count > 25_000_000 {
//            print("Selected file too large: \(mediaData)")
//        } else {
//            print("Approved: \(mediaData)")
//        }
//
//        guard let mediaUrl = try await uploadMediaToFireBase(data: mediaData) else { return }
//
//        try await Firestore.firestore().collection("media").document().setData(["mediaUrl" : mediaUrl, "mimeType" : mimeType(for: mediaData)])
//
//
//        print (" load ok ")
//    }
    
    func uploadMediaToFireBase(data: Data) async throws -> String? {
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference().child("/media/\(fileName)")
        let metaData  = StorageMetadata()
        metaData.contentType = mimeType(for: data)
        
        do {
            let _ = try await ref.putDataAsync(data, metadata: metaData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("Media upload failed: \(error.localizedDescription)")
            return nil
        }
    }
    
//    @MainActor
//    func fetchMedia() async throws {
//        let medias = try await Firestore.firestore().collection("media").getDocuments()
//        self.fetched_media = medias.documents.compactMap { document in
//            do {
//                return try document.data(as: Media.self)
//            } catch {
//                print("Error decoding document: \(error)")
//                return nil
//            }
//        }
//
//
//        for each in medias.documents {
//            print(each)
//        }
//    }
    
    
    
    func createComment(content: String, commentor: String) async throws -> Comment?{
        let commentRef = Firestore.firestore().collection("test_comments").document()
        let comment = Comment(id: commentRef.documentID, content: content, commentor: commentor)
        guard let encodedComment = try? Firestore.Encoder().encode(comment) else {return nil}
        try await commentRef.setData(encodedComment)
        return comment
    }
        
    func createPost(owner: String, postCaption: String?, mediaURL: String?, mimeType: String?) async throws -> Post? {
        let postRef = Firestore.firestore().collection("test_posts").document()
        let post = Post(id: postRef.documentID, owner: owner, postCaption: postCaption, mediaURL: mediaURL, mimeType: mimeType, date: Timestamp())
        guard let encodedPost = try? Firestore.Encoder().encode(post) else {return nil}
        try await postRef.setData(encodedPost)
        return post
    }
    
    func editPost(postID: String, postCaption: String?, mediaURL: String?, mimeType: String?) async throws {
        do {
            let postRef = Firestore.firestore().collection("test_posts").document(postID)
            var post = try await postRef.getDocument().data(as: Post.self)
            
            post.postCaption = postCaption
            post.mediaURL = mediaURL
            post.mimeType = mimeType
            post.date = Timestamp()
            
            try postRef.setData(from: post) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated.")
                }
            }
        } catch {
            throw error
        }
    }
    
    // Add comment to post
    func addCommentToPost(comment: Comment, postID: String) async throws {
        do {
            // Fetch the post document
            let postRef = Firestore.firestore().collection("test_posts").document(postID)
            var post = try await postRef.getDocument().data(as: Post.self)


            // Update the post's comment array
            post.postComment.append(comment.id)

            // Update the Firestore document with the updated data
            try postRef.setData(from: post) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated.")
                }
            }
        } catch {
            throw error
        }
    }
    
    // Delete comment function (delete in comment and in post)
    func deleteComment(postID: String, commentID: String) async throws {
        do {
            let postRef = Firestore.firestore().collection("test_posts").document(postID)
            let commentRef = Firestore.firestore().collection("test_comments").document(commentID)
            var post = try await postRef.getDocument().data(as: Post.self)
       
            // Check if the "postComment" field exists and is an array
            
            // Remove the comment with the specified commentID
            post.postComment.removeAll { $0 == commentID }
            //let updatedData = try Firestore.Encoder().encode(updatedPost)
            // Update the Firestore document with the modified data
            try await commentRef.delete()
            try postRef.setData(from: post) { error in
                if let error = error {
                    print("Error deleting comment: \(error)")
                } else {
                    print("Comment deleted successfully.")
                }
            }
        } catch {
            print("Error deleting comment: \(error)")
            throw error // Rethrow the error for the caller to handle
        }
    }
    
    // Delele post
    func deletePost(postID: String) async throws {
        do {
            let postRef = Firestore.firestore().collection("test_posts").document(postID)
            let post = try await postRef.getDocument().data(as: Post.self)
            // Fetch the post document to get the list of comment IDs
            
            for commentID in post.postComment {
                let commentRef = Firestore.firestore().collection("test_comments").document(commentID ?? "")
                try await commentRef.delete()
            }
            try await postRef.delete()
        } catch {
            print("Error deleting post: \(error)")
            throw error // Rethrow the error for the caller to handle
        }
    }
    
    // Like post
    func likePost(likerID: String, postID: String) async throws {
        do {
            // Fetch the post document
            let postRef = Firestore.firestore().collection("test_posts").document(postID)
            var post = try await postRef.getDocument().data(as: Post.self)

            // Ensure you have successfully fetched the post data
            //var updatedPost = post

            // Update the post's comment array
            if (!post.likers.contains(likerID)) {
                post.likers.append(likerID)
            } else {
                print("Already like")
            }

            // Update the Firestore document with the updated data
            try postRef.setData(from: post) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated.")
                }
            }
        } catch {
            throw error
        }
    }
    
    // Unlike post
    func unLikePost(likerID: String, postID: String) async throws {
        do {
            let postRef = Firestore.firestore().collection("test_posts").document(postID)
            var post = try await postRef.getDocument().data(as: Post.self)
            //var updatedPost = post
            
            // Remove the comment with the specified commentID
            if (post.likers.contains(likerID)) {
                post.likers.removeAll { $0 == likerID }
            } else {
                print("Already unlike")
            }
            
            
            try postRef.setData(from: post) { error in
                if let error = error {
                    print("Error unlike post: \(error)")
                } else {
                    print("Post unlike successfully.")
                }
            }
        } catch {
            print("Error deleting comment: \(error)")
            throw error // Rethrow the error for the caller to handle
        }
    }
    
    
    
    
    @MainActor
    func fetchPost() async throws {
        let post = try await Firestore.firestore().collection("test_posts").getDocuments()
        self.fetched_post = post.documents.compactMap { document in
            do {
                
            
                return try document.data(as: Post.self)
            } catch {
                print("Error decoding document: \(error)")
                return nil
            }
        }
        
        for i in 0..<fetched_post.count {
            for likerID in fetched_post[i].likers {
                let liker = try await UserService.fetchUser(withUid: likerID ?? "")
                fetched_post[i].unwrapLikers.append(liker)
            }
            
            for commentID in fetched_post[i].postComment {
                let comment = try await UserService.fetchComment(withUid: commentID ?? "")
                fetched_post[i].unwrapComments.append(comment)
            }
            
            let post = fetched_post[i]
            let owner = post.owner
            let postUser = try await UserService.fetchUser(withUid: owner)
            fetched_post[i].user = postUser
        }
    }
    
    // Follow
    func followOtherUser(userID: String) async throws {
        //var followingUser = try await UserService.fetchUser(withUid: userID)
        //authVM.currentUser?.following.append(userID)
        //followingUser.followers.append(authVM.currentUser?.id)

        let currentUserRef = Firestore.firestore().collection("users").document("3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        var currentUser = try await currentUserRef.getDocument().data(as: User.self)
        currentUser.following.append(userID)

        let otherUserRef = Firestore.firestore().collection("users").document(userID)
        var otherUser = try await otherUserRef.getDocument().data(as: User.self)
        otherUser.followers.append(currentUser.id)

        try currentUserRef.setData(from: currentUser) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated.")
            }
        }

        try otherUserRef.setData(from: otherUser) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated.")
            }
        }
    }
    
    // Unfollow
    func unFollowOtherUser(userID: String) async throws {
        let currentUserRef = Firestore.firestore().collection("users").document("3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        var currentUser = try await currentUserRef.getDocument().data(as: User.self)
        currentUser.following.removeAll { $0 == userID }

        let otherUserRef = Firestore.firestore().collection("users").document(userID)
        var otherUser = try await otherUserRef.getDocument().data(as: User.self)
        otherUser.followers.removeAll { $0 == currentUser.id }

        try currentUserRef.setData(from: currentUser) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated.")
            }
        }

        try otherUserRef.setData(from: otherUser) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated.")
            }
        }
    }
    
    
    func uploadingPost() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user account")
            return
        }
        
        guard let media = selectedMedia else { return }
        
        guard let mediaData = try await media.loadTransferable(type: Data.self) else { return }
        
        if mediaData.count > 25_000_000 {
            print("Selected file too large: \(mediaData)")
        } else {
            guard let mediaUrl = try await uploadMediaToFireBase(data: mediaData) else { return }
            let postRef = Firestore.firestore().collection("posts").document()
            let post = try? await createPost(owner: uid, postCaption: "Hello world", mediaURL: mediaUrl, mimeType: mimeType(for: mediaData))
            guard let encodedPost = try? Firestore.Encoder().encode(post) else {return}
            try await postRef.setData(encodedPost)
        }
    }
    
    func mimeType(for data: Data) -> String {
        var b: UInt8 = 0
        data.copyBytes(to: &b, count: 1)

        switch b {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x4D, 0x49:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        // Check for common video file formats
        case 0x52:
            // Check for "RIFF" which is a common header in AVI files
            if data.count >= 12 && data[8...11] == Data("AVI ".utf8) {
                return "video/avi"
            }
        case 0x00:
            // Check for video formats like MP4
                   if data.count >= 12 && data[4...7] == Data("ftyp".utf8) {
                       return "video/mp4"
                   }
            
           // Check for MOV format
           if data.count >= 4 && data[4...7] == Data("ftyp".utf8) && data[8...11] == Data("qt  ".utf8) {
               return "video/quicktime"
           }
        case 0x1A:
            // Check for video formats like MKV
            if data.count >= 4 && data[1...3] == Data("webm".utf8) {
                return "video/webm"
            }
        // Add more checks for specific file formats here
        default:
            return "application/octet-stream"
        }

        return "application/octet-stream"
    }
}
