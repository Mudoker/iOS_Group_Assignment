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
    @Published var selectedPostTag: [String] = []
    @Published var selectedUserTag: [String] = []
    @Published var isShowUserTagListOnIphone = false
    @Published var isShowUserTagListOnIpad = false
    @Published var userTagListSearchText = ""
    @Published var postTagListSearchText = ""
    @Published var isShowPostTagListOnIphone = false
    @Published var isShowPostTagListOnIpad = false
    @Published var createNewPostCaption = ""
    @Published var isPostOnScreen = false
    @Published var isRestrictUserAlert = false
    @Published var isBlockUserAlert = false
    @Published var isDeletePostAlert = false
    @Published var isTurnOffCommentAlert = false
    @Published var selectedCommentFilter = "Newest"
    @Published var fetchedAllPosts = [Post]()
    private var postsListenerRegistration: ListenerRegistration?
    private var commentListenerRegistration: ListenerRegistration?
    
    
    @Published var fetchedCommentsByPostId = [String: Set<Comment>]()
    
    @Published var newPostSelectedMedia: NSURL? = nil
    @Published var currentCommentor: User?
    
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
        UIDevice.current.userInterfaceIdiom == .phone ? 18 : 25
    }
    
    var timeFont: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 15 : 20
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
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width * 0.1 : proxySize.width * 0.08
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
            print(existingComments)
        }
    }
    
    //upload the media data to database storage
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
        let newComment = Comment(id: commentRef.documentID, content: content, commenterId: commentor, postId: postId, creationDate: Timestamp())
        guard let encodedComment = try? Firestore.Encoder().encode(newComment) else { return nil }
        try await commentRef.setData(encodedComment)
        return newComment
    }
    
    //create post and upload to firebase collection
    func createPost() async throws {
        let ownerID = Auth.auth().currentUser?.uid ?? "fail"
        let postRef = Firestore.firestore().collection("test_posts").document()
        
        var mediaURL = ""
        var mediaMimeType = ""
        
        if newPostSelectedMedia != nil{
            mediaURL = try await createMediaToFirebase()
            mediaMimeType = mimeType(for: try Data(contentsOf: newPostSelectedMedia as? URL ?? URL(fileURLWithPath: "")))
        }
        
        print(mediaURL)
        let newPost = Post(
            id: postRef.documentID,
            ownerID: ownerID,
            caption: createNewPostCaption,
            mediaURL: mediaURL,
            mediaMimeType: mediaMimeType,
            tag: selectedPostTag,
            creationDate: Timestamp(),
            isAllowComment: true,
            author: nil,
            user: nil,
            unwrappedLikers: []
        )
        print("create Post")
        guard let encodedPost = try? Firestore.Encoder().encode(newPost) else {
            print("fail to encode Post")
            return}
        try await postRef.setData(encodedPost)
        
        print("uploaded")
        return
    }
    
    func toggleCommentOnPost(postID: String, isDisable: Bool) async throws {
        do {
            let postRef = Firestore.firestore().collection("test_posts").document(postID)
            var post = try await postRef.getDocument().data(as: Post.self)
            post.isAllowComment = isDisable
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
    
    //sort post
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
    
    
    //sort the comment
    func sortPostCommentByTime(order: String, comments: [Comment]) -> [Comment] {
        var sortedComments = comments
        
        switch order {
        case "asc":
            sortedComments.sort { cmt1, cmt2 in
                return cmt1.creationDate.dateValue().compare(cmt2.creationDate.dateValue()) == ComparisonResult.orderedAscending
            }
        case "desc":
            sortedComments.sort { cmt1, cmt2 in
                return cmt1.creationDate.dateValue().compare(cmt2.creationDate.dateValue()) == ComparisonResult.orderedDescending
            }
        default:
            break
        }
        
        return sortedComments
    }
    
    //Filter category of post: show post with the filtered category
    func filterPostByCategory(category: [String], posts: [Post]) -> [Post] {
        var filteredPosts: [Post] = []
        
        for post in posts {
            // Check if the post has any category tags that match the desired categories
            let matchingCategories = post.tag.filter { category.contains($0) }
            
            if !matchingCategories.isEmpty {
                // If at least one matching category is found, add the post to the filtered list
                filteredPosts.append(post)
            }
        }
        
        return filteredPosts
    }
    
    // Only applied for current User (Hide all post form block list and restriected list)
    func filterPostsAndCommentsByLists(restrictedList: [String], blockedList: [String], posts: [Post], comments: [Comment]) -> ([Post], [Comment]) {
        var filteredPosts: [Post] = []
        var filteredComments: [Comment] = []
        
        for post in posts {
            // Check if the post owner's ID is not in the restricted or blocked list
            if !restrictedList.contains(post.ownerID) && !blockedList.contains(post.ownerID) {
                filteredPosts.append(post)
            }
        }
        
        for comment in comments {
            // Check if the commenter's ID is not in the restricted or blocked list
            if !restrictedList.contains(comment.commenterId) && !blockedList.contains(comment.commenterId) {
                filteredComments.append(comment)
            }
        }
        
        return (filteredPosts, filteredComments)
    }
    
    // Only applied for other User (if B is blocked by A, then A and B cannot see post each other)
    func filterPostsAndCommentsByLists(blockedList: [String], posts: [Post], comments: [Comment]) -> ([Post], [Comment]) {
        var filteredPosts: [Post] = []
        var filteredComments: [Comment] = []
        
        for post in posts {
            // Check if the post owner's ID is not in the restricted or blocked list
            if !blockedList.contains(post.ownerID) {
                filteredPosts.append(post)
            }
        }
        
        for comment in comments {
            // Check if the commenter's ID is not in the restricted or blocked list
            if !blockedList.contains(comment.commenterId) {
                filteredComments.append(comment)
            }
        }
        
        return (filteredPosts, filteredComments)
    }
    
    // Like post
    func likePost(likerID: String, postID: String) async throws {
        do {
            // Fetch the post document
            let userRef = Firestore.firestore().collection("users").document(likerID)
            var user = try await userRef.getDocument().data(as: User.self)
            
   
            
            // Update the post's comment array
            if (!user.likedPost.contains(postID)) {
                user.likedPost.append(postID)
            } else {
                user.likedPost.removeAll { $0 == postID}
            }
            // Update the Firestore document with the updated data
//            try postRef.setData(from: post) { error in
//                if let error = error {
//                    print("Error updating document: \(error)")
//                } else {
//                    print("Document successfully updated.")
//                }
//            }
        } catch {
            throw error
        }
    }
    
    // Unlike post
//    func unLikePost(likerID: String, postID: String) async throws {
//        do {
//            let postRef = Firestore.firestore().collection("test_posts").document(postID)
//            var post = try await postRef.getDocument().data(as: Post.self)
//            //var updatedPost = post
//
//            // Remove the comment with the specified commentID
//            if (post.likerIDs.contains(likerID)) {
//                post.likerIDs.removeAll { $0 == likerID }
//            } else {
//                print("Already unlike")
//            }
//
//
//            try postRef.setData(from: post) { error in
//                if let error = error {
//                    print("Error unlike post: \(error)")
//                } else {
//                    print("Post unlike successfully.")
//                }
//            }
//        } catch {
//            print("Error deleting comment: \(error)")
//            throw error // Rethrow the error for the caller to handle
//        }
//    }
    
    // Block (not receiving notification + post/story + message + other cannot see your post)
    func blockOtherUser(userID: String) async throws {
        let currentUserRef = Firestore.firestore().collection("users").document(Constants.currentUserID)
        var currentUser = try await currentUserRef.getDocument().data(as: User.self)
        let otherUserRef = Firestore.firestore().collection("users").document("3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        var otherUser = try await currentUserRef.getDocument().data(as: User.self)
        currentUser.blockList.append(userID)
        otherUser.blockByList.append(Constants.currentUserID)
        
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
    
    // Unblock
    func unBlockOtherUser(userID: String) async throws {
        let currentUserRef = Firestore.firestore().collection("users").document(Constants.currentUserID)
        var currentUser = try await currentUserRef.getDocument().data(as: User.self)
        let otherUserRef = Firestore.firestore().collection("users").document("3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        var otherUser = try await currentUserRef.getDocument().data(as: User.self)
        
        currentUser.blockList.removeAll { $0 == userID }
        otherUser.blockList.removeAll { $0 == Constants.currentUserID }
        
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
    
    // restrict (not receiving notification + post/story + other can still see your posts)
    func restrictOtherUser(userID: String) async throws {
        let currentUserRef = Firestore.firestore().collection("users").document(Constants.currentUserID)
        var currentUser = try await currentUserRef.getDocument().data(as: User.self)
        let otherUserRef = Firestore.firestore().collection("users").document("3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        var otherUser = try await currentUserRef.getDocument().data(as: User.self)
        currentUser.restrictedByList.append(userID)
        otherUser.restrictedByList.append(Constants.currentUserID)
        
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
    
    // Un-restrict
    func unRestrictOtherUserBlockOtherUser(userID: String) async throws {
        let currentUserRef = Firestore.firestore().collection("users").document(Constants.currentUserID)
        var currentUser = try await currentUserRef.getDocument().data(as: User.self)
        let otherUserRef = Firestore.firestore().collection("users").document("3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        var otherUser = try await currentUserRef.getDocument().data(as: User.self)
        currentUser.restrictedList.removeAll { $0 == userID }
        otherUser.restrictedByList.removeAll { $0 == Constants.currentUserID }
        
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
    
//   
    
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
    
    //convert the media data and upload to firebase and return the url of the media storage
    func createMediaToFirebase() async throws -> String {
        print("Uploading media")
        
        guard let selectedMedia = newPostSelectedMedia else {
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
