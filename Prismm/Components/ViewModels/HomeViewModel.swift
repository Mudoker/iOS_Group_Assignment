/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Apple Men
 Doan Huu Quoc (s3927776)
 Tran Vu Quang Anh (s3916566)
 Nguyen Dinh Viet (s3927291)
 Nguyen The Bao Ngoc (s3924436)
 
 Created  date: 09/09/2023
 Last modified: 09/09/2023
 Acknowledgement: None
 */
import Foundation
import PhotosUI
import SwiftUI
import Firebase
import FirebaseStorage
import MobileCoreServices
import AVFoundation
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    @Published var isCreateNewPostOnIpad = false
    @Published var isCreateNewPostOnIphone = false
    @Published var isOpenCommentViewOnIphone = false
    @Published var isOpenCommentViewOnIpad = false
    @Published var commentContent = ""
    @Published var selectedPostTagList: [String] = []
    @Published var selectedUserTagList: [String] = []
    @Published var isShowUserTagListOnIphone = false
    @Published var isShowUserTagListOnIpad = false
    @Published var userTagListSearchText = ""
    @Published var postTagListSearchText = ""
    @Published var isShowPostTagListOnIphone = false
    @Published var isShowPostTagListOnIpad = false
    @Published var createNewPostCaption = ""
    @Published var createNewPostTag: [String] = []
    @Published var isPostOnScreen = false
    @Published var selectedCommentFilter = "Newest"
    @Published var fetchedAllPosts = [Post]()
    private var postsListenerRegistration: ListenerRegistration?
    private var commentListenerRegistration: ListenerRegistration?
    @Published var selectedMedia: NSURL?
    @Published var fetchedCommentsByPostId = [String: Set<Comment>]()
    
    @Published var newPostSelectedMedia: PhotosPickerItem? {
        didSet {
            Task {
                try await uploadMediaToFirebase()
            }
        }
    }
    var currentCommentor: User?
    // Responsive
    @Published var proxySize: CGSize = CGSize(width: 0, height: 0)
    
    var cornerRadius: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 40 : proxySize.width / 50
    }
    
    var accountSettingHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 4 : proxySize.height / 8
    }
    
    var accountSettingImageWidth: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 8 : proxySize.width / 12
    }
    
    var accountSettingUsernameFont: Font {
        UIDevice.current.userInterfaceIdiom == .phone ? .title3 : .title
    }
    
    var accountSettingEmailFont: Font {
        .body
    }
    
    var contentFont: Font {
        UIDevice.current.userInterfaceIdiom == .phone ? .body : .title3
    }
    
    var imageSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 18 : proxySize.width / 28
    }
    
    var storyViewWidth: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width * 0.2 : proxySize.width * 0.15
    }
    
    var storyViewHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width * 0.23 : proxySize.width * 0.15
    }
    
    var appLogoSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 2 : proxySize.width / 7
    }
    
    var messageLogoSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 14 : proxySize.width * 0.06
    }
    
    var profileImageSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width * 0.15 : proxySize.width * 0.1
    }
    
    var usernameFont: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 20 : 25
    }
    
    var seeMoreButtonSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width * 0.055 : proxySize.width * 0.055
    }
    
    var postStatsFontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width * 0.04 : proxySize.width * 0.03
    }
    
    var postStatsImageSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width * 0.05 : proxySize.width * 0.04
    }
    
    var commentProfileImageSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width * 0.1 : proxySize.width * 0.08
    }
    
    var commentTextFieldHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width * 0.1 : proxySize.width * 0.08
    }
    
    var commentTextFiledFont: Font {
        UIDevice.current.userInterfaceIdiom == .phone ? .caption : .title
    }
    
    var captionFont: Font {
        UIDevice.current.userInterfaceIdiom == .phone ? .title3 : .title
        
    }
    
    var commentTextFieldCornerRadius: CGFloat {
        15
    }
    
    init() {
        Task {
            await fetchPostsRealTime()
        }
    }
    
    @MainActor
    func fetchAllComments(forPostID postID: String) {
        commentListenerRegistration = Firestore.firestore().collection("test_comments").whereField("postId", isEqualTo: postID).addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let commentsToAdd = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Comment.self)
            }
            
            // Check if "postID" exists in fetched_comments, and if not, create an empty set
            var existingComments = fetchedCommentsByPostId[postID, default: Set<Comment>()]
            
            // Add the comments to the existing set
            existingComments.formUnion(commentsToAdd)
            
            // Update the fetched_comments dictionary with the merged set of comments
            fetchedCommentsByPostId[postID] = existingComments
        }
    }
    
    func uploadMediaToFireBase(withMedia data: Data) async throws -> String? {
        let fileName = UUID().uuidString
        let mediaRef = Storage.storage().reference().child("/media/\(fileName)")
        let metaData  = StorageMetadata()
        metaData.contentType = mimeType(for: data)
        
        do {
            let _ = try await mediaRef.putDataAsync(data, metadata: metaData)
            let downloadURL = try await mediaRef.downloadURL()
            return downloadURL.absoluteString
        } catch {
            print("Media upload failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    func createComment(content: String, commentor: String, postId: String) async throws -> Comment?{
        let commentRef = Firestore.firestore().collection("test_comments").document()
        let newComment = Comment(id: commentRef.documentID, content: content, commenterID: commentor, postID: postId)
        guard let encodedComment = try? Firestore.Encoder().encode(newComment) else { return nil }
        try await commentRef.setData(encodedComment)
        return newComment
    }
    
    func createPost(ownerID: String, postCaption: String?, postTag: [String], mediaURL: String?, mimeType: String?) async throws -> Post? {
        let postRef = Firestore.firestore().collection("test_postTag").document()
        let newPost = Post(
            id: postRef.documentID,
            ownerID: ownerID,
            caption: postCaption,
            likerIDs: [],
            mediaURL: mediaURL,
            mediaMimeType: mimeType,
            tag: postTag,
            creationDate: Timestamp(),
            author: nil,
            user: nil,
            unwrappedLikers: []
        )
        
        guard let encodedPost = try? Firestore.Encoder().encode(newPost) else {return nil}
        try await postRef.setData(encodedPost)
        return newPost
    }
    
    func editCurrentPost(postID: String, newPostCaption: String?, newMediaURL: String?, newMimeType: String?) async throws {
        do {
            let postRef = Firestore.firestore().collection("test_posts").document(postID)
            var post = try await postRef.getDocument().data(as: Post.self)
            
            post.caption = newPostCaption
            post.mediaURL = newMediaURL
            post.mediaMimeType = newMimeType
            post.creationDate = Timestamp()
            
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
    
    @MainActor
    func fetchPostsRealTime() {
        if postsListenerRegistration == nil {
            postsListenerRegistration = Firestore.firestore().collection("test_posts").addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching posts: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.fetchedAllPosts = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Post.self)
                }
                
                self.fetchedAllPosts = sortPostByTime(order: "asc", posts: self.fetchedAllPosts)
                
                for i in 0..<self.fetchedAllPosts.count {
                    for likerID in self.fetchedAllPosts[i].likerIDs {
                        Task {
                            do {
                                let liker = try await APIService.fetchUser(withUserID: likerID ?? "")
                                self.fetchedAllPosts[i].unwrappedLikers.append(liker)
                            } catch {
                                print("Error fetching liker: \(error)")
                            }
                        }
                    }
                    
                    let post = self.fetchedAllPosts[i]
                    let ownerID = post.ownerID
                    Task {
                        do {
                            let postUser = try await APIService.fetchUser(withUserID: ownerID)
                            self.fetchedAllPosts[i].user = postUser
                        } catch {
                            print("Error fetching post user: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func sortPostByTime(order: String, posts: [Post]) -> [Post] {
        var sortedPosts = posts
        
        switch order {
        case "asc":
            sortedPosts.sort { post1, post2 in
                return post1.creationDate.dateValue().compare(post2.creationDate.dateValue()) == ComparisonResult.orderedAscending
            }
        case "desc":
            sortedPosts.sort { post1, post2 in
                return post1.creationDate.dateValue().compare(post2.creationDate.dateValue()) == ComparisonResult.orderedDescending
            }
        default:
            break
        }
        
        return sortedPosts
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
            if (!post.likerIDs.contains(likerID)) {
                post.likerIDs.append(likerID)
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
            if (post.likerIDs.contains(likerID)) {
                post.likerIDs.removeAll { $0 == likerID }
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
    
    // Block (not receiving notification + post/story + message)
    func blockOtherUser(userID: String) async throws {
        let currentUserRef = Firestore.firestore().collection("users").document("3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        var currentUser = try await currentUserRef.getDocument().data(as: User.self)
        currentUser.blockList.append(userID)
        
        try currentUserRef.setData(from: currentUser) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated.")
            }
        }
    }
    
    // Unblock
    func unBlockOtherUser(userID: String) async throws {
        let currentUserRef = Firestore.firestore().collection("users").document("3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        var currentUser = try await currentUserRef.getDocument().data(as: User.self)
        currentUser.blockList.removeAll { $0 == userID }
        
        try currentUserRef.setData(from: currentUser) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated.")
            }
        }
    }
    
    // restrict (not receiving notification + post/story)
    func restrictOtherUser(userID: String) async throws {
        let currentUserRef = Firestore.firestore().collection("users").document("3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        var currentUser = try await currentUserRef.getDocument().data(as: User.self)
        currentUser.restrictedList.append(userID)
        
        try currentUserRef.setData(from: currentUser) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated.")
            }
        }
    }
    
    // Un-restrict
    func unRestrictOtherUserBlockOtherUser(userID: String) async throws {
        let currentUserRef = Firestore.firestore().collection("users").document("3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        var currentUser = try await currentUserRef.getDocument().data(as: User.self)
        currentUser.restrictedList.removeAll { $0 == userID }
        
        try currentUserRef.setData(from: currentUser) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated.")
            }
        }
    }
    
    // Follow
    func followOtherUser(userID: String) async throws {
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
    
    
    func uploadMediaToFirebase() async throws -> String {
        print("Uploading media")
        
        guard let selectedMedia = selectedMedia else {
            print("Failed to get data")
            return ""
        }
        print(selectedMedia)
        
        do {
            let mediaData = try Data(contentsOf: selectedMedia as URL)
            print("Completed converting data")
            
            if mediaData.count > 25_000_000 {
                print("Selected file too large: \(mediaData)")
                return ""
            }
            
            guard let mediaUrl = try await uploadMediaToFireBase(withMedia: mediaData) else {
                return ""
            }
            
            print("Uploaded media data to Firebase")
            
            let postRef = Firestore.firestore().collection("posts").document()
            let post = try? await createPost(ownerID: Constants.currentUserID, postCaption: "Hello world", postTag: [], mediaURL: mediaUrl, mimeType: mimeType(for: mediaData))
            
            guard let encodedPost = try? Firestore.Encoder().encode(post) else {
                return ""
            }
            
            try await postRef.setData(encodedPost)
            return mediaUrl
        } catch {
            print("Failed to upload post: \(error)")
            return ""
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
