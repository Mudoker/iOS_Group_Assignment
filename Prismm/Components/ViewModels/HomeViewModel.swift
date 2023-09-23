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
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    // State control
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
    @Published var isSignOutAlertPresented = false
    @Published var selectedCommentFilter = "Newest"
    
    // Firebase Listener
    private var commentListenerRegistration: ListenerRegistration?
    private var likePostListenerRegistration: ListenerRegistration?
    private var favouritePostListenerRegistration: ListenerRegistration?
    private var currentUserBlockListListenerRegistration: ListenerRegistration?
    private var currentUserRestrictListListenerRegistration: ListenerRegistration?
    private var currentUserFollowListListenerRegistration: ListenerRegistration?

    // Fetched values
    @Published var fetchedCommentsByPostId = [String: Set<Comment>]()
    @Published var currentUserBlockList = [UserBlockList]()
    @Published var currentUserFollowList = [UserFollowList]()
    @Published var currentUserRestrictList = [UserRestrictList]()
    @Published var fetchedAllPosts = [Post]()
    @Published var fetchedAllStories = [Story]()
    @Published var currentUserFavouritePost = [FavouritePost]()
    
    
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
        UIDevice.current.userInterfaceIdiom == .phone ? 20 : 25
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

    // Fetch all comments for a post
    @MainActor
    func fetchAllComments(forPostID postID: String) {
        // Listen for changes in the "test_comments" collection
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
            
            // Convert query results to Comment objects
            let commentsToAdd = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Comment.self)
            }
            
            // If "postID" not in fetched comments -> create an empty set
            var existingComments = fetchedCommentsByPostId[postID, default: Set<Comment>()]
            
            // Add the comments to the existing set
            existingComments.formUnion(commentsToAdd)
            
            // Update the fetched_comments dictionary with the merged set of comments
            fetchedCommentsByPostId[postID] = existingComments
        }
    }
    
    // check if user has archived this post
    func isUserFavouritePost(withPostId postId: String, withUserId userId: String) -> Bool {
        return currentUserFavouritePost.contains { post in
            post.ownerId == userId && post.postId == postId
        }
    }
    
    // Fetch current user block list
    @MainActor
    func fetchCurrentUserBlockList() {
        // Add lisener to collection
        currentUserBlockListListenerRegistration = Firestore.firestore().collection("test_block").whereField("ownerId", isEqualTo: "ao2PKDpap4Mq7M5cn3Nrc1Mvoa42").addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching block list: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            // Convert query results to UserBlockList objects
            self.currentUserBlockList = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: UserBlockList.self)
            }
        }
    }
    
    // Fetch the current user restrict list
    @MainActor
    func fetchCurrentUserRestrictList() {
        currentUserBlockListListenerRegistration = Firestore.firestore().collection("test_restrict").whereField("ownerId", isEqualTo: "ao2PKDpap4Mq7M5cn3Nrc1Mvoa42").addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching restrict list: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            // Convert query results to UserRestrictList objects
            self.currentUserRestrictList = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: UserRestrictList.self)
            }
        }
    }
    
    // Fetch the current user follow list
    @MainActor
    func fetchCurrentUserFollowList() {
        currentUserFollowListListenerRegistration = Firestore.firestore().collection("test_follow").whereField("ownerId", isEqualTo: "ao2PKDpap4Mq7M5cn3Nrc1Mvoa42").addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching follow list: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            // Convert query results to UserFollowList objects
            self.currentUserFollowList = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: UserFollowList.self)
            }
        }
    }
    
    // Fetch all user favorite posts
    @MainActor
    func fetchUserFavouritePost(forUserId userId: String) {
        favouritePostListenerRegistration = Firestore.firestore().collection("test_favourites").whereField("ownerId", isEqualTo: userId).addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            // Convert query results to FavouritePost objects
            self.currentUserFavouritePost = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: FavouritePost.self)
            }
        }
    }
    
    // Create new comment
    func createComment(content: String, commentor: String, postId: String) async throws -> Comment?{
        let commentRef = Firestore.firestore().collection("test_comments").document()
        let newComment = Comment(id: commentRef.documentID, content: content, commenterId: commentor, postId: postId, creationDate: Timestamp())
        
        // Encode and store the new comment data
        guard let encodedComment = try? Firestore.Encoder().encode(newComment) else { return nil }
        try await commentRef.setData(encodedComment)
        return newComment
    }
    
    // Like a post
    func likePost(likerId: String, postId: String) async throws {
        do {
            let likedPostsCollection = Firestore.firestore().collection("test_likes")
            
            // Check if the user has liked the post
            let query = likedPostsCollection.whereField("postId", isEqualTo: postId).whereField("likerId", isEqualTo: likerId)
            
            let querySnapshot = try await query.getDocuments()
            
            // No document -> User has not liked it -> allow like
            if querySnapshot.isEmpty {
                let likedPostRef = Firestore.firestore().collection("test_likes").document()
                let likedPost = LikedPost(id: likedPostRef.documentID, likerId: likerId, postId: postId)
                
                // Encode and store the liked post
                guard let encodedLikedPost = try? Firestore.Encoder().encode(likedPost) else { return }
                try await likedPostRef.setData(encodedLikedPost)
            }
        } catch {
            throw error
        }
    }
    
    // Archive a post
    func favorPost(ownerId: String, postId: String) async throws {
        do {
            let likedPostsCollection = Firestore.firestore().collection("test_favourites")
            
            // Check if the user has already archived the post
            let query = likedPostsCollection.whereField("postId", isEqualTo: postId).whereField("ownerId", isEqualTo: ownerId)
            
            let querySnapshot = try await query.getDocuments()
            
            // No document -> User has not archived it -> allow archive
            if querySnapshot.isEmpty {
                let likedPostRef = Firestore.firestore().collection("test_favourites").document()
                let likedPost = FavouritePost(id: likedPostRef.documentID, ownerId: ownerId, postId: postId)
                
                // Encode and store the favorite post
                guard let encodedLikedPost = try? Firestore.Encoder().encode(likedPost) else { return }
                try await likedPostRef.setData(encodedLikedPost)
            }
        } catch {
            throw error
        }
    }
    
    // Unlike a post
    func unLikePost(likerId: String, postId: String) async throws {
        do {
            let likedPostsCollection = Firestore.firestore().collection("test_likes")
            
            // Fetch LikedPost documents with matching postId and likerId
            let query = likedPostsCollection.whereField("postId", isEqualTo: postId).whereField("likerId", isEqualTo: likerId)
            
            let querySnapshot = try await query.getDocuments()
            
            for document in querySnapshot.documents {
                // Delete the LikedPost document
                let documentRef = Firestore.firestore().collection("test_likes").document(document.documentID)
                try await documentRef.delete()
            }
            print("unlike")
        } catch {
            print("Error unliking post: \(error)")
            throw error
        }
    }
    
    // Unarchive a post
    func unFavorPost(ownerId: String, postId: String) async throws {
        do {
            let likedPostsCollection = Firestore.firestore().collection("test_favourites")
            
            // Fetch LikedPost documents with matching postId and likerId
            let query = likedPostsCollection.whereField("postId", isEqualTo: postId).whereField("ownerId", isEqualTo: ownerId)
            
            let querySnapshot = try await query.getDocuments()
            
            for document in querySnapshot.documents {
                // Delete the LikedPost document
                let documentRef = Firestore.firestore().collection("test_favourites").document(document.documentID)
                try await documentRef.delete()
            }
        } catch {
            print("Error unliking post: \(error)")
            throw error
        }
    }
    
    // Create new post and upload to Firebase
    func createStory() async throws {
        // Get the current user id
        let ownerID = Auth.auth().currentUser?.uid ?? "fail"
        
        // Reference to the story collection
        let storyRef = Firestore.firestore().collection("test_stories").document()
        
        // Initialize variables for media URL and MIME type
        var mediaURL = ""
        var mediaMimeType = ""
        
        // Check selected media for the story
        if newPostSelectedMedia != nil{
            mediaURL = try await APIService.createMediaToFirebase(newPostSelectedMedia: newPostSelectedMedia!)
            mediaMimeType = mimeType(for: try Data(contentsOf: newPostSelectedMedia as? URL ?? URL(fileURLWithPath: "")))
        }
        
        // Create a new story object with provided data
        let newStory = Story(id: storyRef.documentID, creationDate: Timestamp(), isActive: true, mediaURL: mediaURL, mediaMimeType: mediaMimeType, ownerId: ownerID)
        
        // Encode and store it in Firestore
        guard let encodedStory = try? Firestore.Encoder().encode(newStory) else { return }
        try await storyRef.setData(encodedStory)
    }
    
    // Create new post and upload to Firebase
    func createPost() async throws {
        // Get the current user id
        let ownerID = Auth.auth().currentUser?.uid ?? "fail"
        
        // Reference to the post collection
        let postRef = Firestore.firestore().collection("test_posts").document()
        
        // Initialize variables for media URL and MIME type
        var mediaURL = ""
        var mediaMimeType = ""
        
        // Check selected media for the post
        if newPostSelectedMedia != nil{
            mediaURL = try await APIService.createMediaToFirebase(newPostSelectedMedia: newPostSelectedMedia!)
            mediaMimeType = mimeType(for: try Data(contentsOf: newPostSelectedMedia as? URL ?? URL(fileURLWithPath: "")))
        }
        
        // Create a new post object with provided data
        let newPost = Post(
            id: postRef.documentID,
            ownerID: ownerID,
            caption: createNewPostCaption,

            mediaURL: mediaURL,
            mediaMimeType: mediaMimeType,
            tag: selectedPostTag,
            creationDate: Timestamp(),
            isAllowComment: true
        )
        
        // Encode and store it in Firestore
        guard let encodedPost = try? Firestore.Encoder().encode(newPost) else { return }
        try await postRef.setData(encodedPost)
    }
    
    // Toggle comment functionality on a post
    func toggleCommentOnPost(postID: String, isDisable: Bool) async throws {
        do {
            // Get a reference to the post
            let postRef = Firestore.firestore().collection("test_posts").document(postID)
            
            // Retrieve the post data
            var post = try await postRef.getDocument().data(as: Post.self)
            
            // Update the comment status
            post.isAllowComment = isDisable
            
            // Set the updated post data back to Firestore
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
    
    // Edit the current post
    func editCurrentPost(postID: String, newPostCaption: String?, newMediaURL: String?, newMimeType: String?) async throws {
        do {
            // Get a reference to the post
            let postRef = Firestore.firestore().collection("test_posts").document(postID)
            
            // Retrieve the post data
            var post = try await postRef.getDocument().data(as: Post.self)
            
            
            // Update post properties with new values
            post.caption = newPostCaption
            post.mediaURL = newMediaURL
            post.mediaMimeType = newMimeType
            post.creationDate = Timestamp()
            
            // Set the updated post data back to Firestore
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
    
    // Fetch posts from Firestore
    @MainActor
    func fetchPosts() async throws {
        do {
            // Query Firestore to get all posts
            let querySnapshot = try await Firestore.firestore().collection("test_posts").getDocuments()
            
            if querySnapshot.isEmpty {
                print("No documents")
                return
            }
            
            var fetchedAllPosts = [Post]()
            
            // Iterate and convert to Post objects
            for queryDocumentSnapshot in querySnapshot.documents {
                if let post = try? queryDocumentSnapshot.data(as: Post.self) {
                    fetchedAllPosts.append(post)
                }
            }
            
            // Sort the fetched posts by time in descending order
            fetchedAllPosts = sortPostByTime(order: "desc", posts: fetchedAllPosts)
            
            // Fetch user for each post's owner
            for i in 0..<fetchedAllPosts.count {
                let post = fetchedAllPosts[i]
                let ownerID = post.ownerID
                
                do {
                    let user = try await APIService.fetchUser(withUserID: ownerID)
                    fetchedAllPosts[i].unwrappedOwner = user
                } catch {
                    print("Error fetching user: \(error)")
                }
            }
            
            // Update the fetched posts array
            self.fetchedAllPosts = fetchedAllPosts
        } catch {
            print("Error fetching posts: \(error)")
            throw error
        }
    }

    // Fetch stories from Firestore
    @MainActor
    func fetchStories() async throws {
        do {
            // Query Firestore to get all posts
            let querySnapshot = try await Firestore.firestore().collection("test_stories").getDocuments()
            
            if querySnapshot.isEmpty {
                print("No documents")
                return
            }
            
            var fetchedAllStory = [Story]()
            
            // Iterate and convert to Post objects
            for queryDocumentSnapshot in querySnapshot.documents {
                if let story = try? queryDocumentSnapshot.data(as: Story.self) {
                    fetchedAllStory.append(story)
                }
            }
            
            // Sort the fetched posts by time in descending order
            fetchedAllStory = sortStoryByTime(order: "desc", stories: fetchedAllStory)
            
            // Fetch user for each post's owner
            for i in 0..<fetchedAllStory.count {
                let story = fetchedAllStory[i]
                let ownerID = story.ownerId
                
                do {
                    let user = try await APIService.fetchUser(withUserID: ownerID)
                    fetchedAllStory[i].unwrappedOwner = user
                } catch {
                    print("Error fetching user: \(error)")
                }
            }
            
            // Update the fetched posts array
            self.fetchedAllStories = fetchedAllStory
        } catch {
            print("Error fetching stories: \(error)")
            throw error
        }
    }

    //Sort post by creation date
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
    
    //Sort story by creation date
    func sortStoryByTime(order: String, stories: [Story]) -> [Story] {
        var sortedStories = stories
        
        switch order {
        case "asc":
            sortedStories.sort { post1, post2 in
                return post1.creationDate.dateValue().compare(post2.creationDate.dateValue()) == ComparisonResult.orderedAscending
            }
        case "desc":
            sortedStories.sort { post1, post2 in
                return post1.creationDate.dateValue().compare(post2.creationDate.dateValue()) == ComparisonResult.orderedDescending
            }
        default:
            break
        }
        
        return sortedStories
    }
    
    //sort the comment by created date
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
                // add the post to the filtered list
                filteredPosts.append(post)
            }
        }
        return filteredPosts
    }
    
    // Filter posts and comments based on restricted and blocked lists for the current user
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
    
    // Filter posts and comments to prevent interactions between blocked users
    func filterPostsAndCommentsByLists(beBlockedList: [String], posts: [Post], comments: [Comment]) -> ([Post], [Comment]) {
        var filteredPosts: [Post] = []
        var filteredComments: [Comment] = []
        
        for post in posts {
            // Check if the post owner's ID is not in the restricted or blocked list
            if !beBlockedList.contains(post.ownerID) {
                filteredPosts.append(post)
            }
        }
        
        for comment in comments {
            // Check if the commenter's ID is not in the restricted or blocked list
            if !beBlockedList.contains(comment.commenterId) {
                filteredComments.append(comment)
            }
        }
        
        return (filteredPosts, filteredComments)
    }
    
    // Block (not receiving notification + post/story + message + other cannot see your post)
    func blockOtherUser(forUserID userIDToBlock: String) async throws {
        do {
            let userBlockListCollection = Firestore.firestore().collection("test_block")
            let currentUserID = "ao2PKDpap4Mq7M5cn3Nrc1Mvoa42" //MARK: Replace with the actual current user's ID
            
            // Use a Firestore query to check if the user has already blocked another user
            let queryCurrentUserBlockList = userBlockListCollection.whereField("ownerId", isEqualTo: currentUserID)
            let queryBlockedUserBlockList = userBlockListCollection.whereField("ownerId", isEqualTo: userIDToBlock)
            
            // Get block list of both users
            let querySnapshotCurrentUserBlockList = try await queryCurrentUserBlockList.getDocuments()
            let querySnapshotBlockedUserBlockList = try await queryBlockedUserBlockList.getDocuments()
            
            // If there are no matching documents, it means the user hasn't blocked anyone, so create a new block list
            if querySnapshotCurrentUserBlockList.isEmpty {
                // Create a new block list
                let blockListRef = userBlockListCollection.document()
                let blockList = UserBlockList(id: blockListRef.documentID, ownerId: currentUserID, blockedIds: [userIDToBlock], beBlockedBy: [])
                
                guard let encodedBlockList = try? Firestore.Encoder().encode(blockList) else {
                    return
                }
                
                try await blockListRef.setData(encodedBlockList)
            } else {
                // If the block list exists, add the user ID to the blockedIds array
                guard let blockListDocument = querySnapshotCurrentUserBlockList.documents.first else {
                    return
                }
                
                let existingBlockedIds = blockListDocument["blockedIds"] as? [String] ?? []
                if !existingBlockedIds.contains(userIDToBlock) {
                    var updatedBlockedIds = existingBlockedIds
                    updatedBlockedIds.append(userIDToBlock)
                    
                    try await userBlockListCollection.document(blockListDocument.documentID).updateData(["blockedIds": updatedBlockedIds])
                }
            }
            
            // If there are no matching documents, it means the user hasn't blocked anyone, so create a new block list
            if querySnapshotBlockedUserBlockList.isEmpty {
                // Create a new block list
                let blockListRef = userBlockListCollection.document()
                let blockList = UserBlockList(id: blockListRef.documentID, ownerId: userIDToBlock, blockedIds: [], beBlockedBy: [currentUserID])
                
                guard let encodedBlockList = try? Firestore.Encoder().encode(blockList) else {
                    return
                }
                
                try await blockListRef.setData(encodedBlockList)
            } else {
                // If the block list exists, add the user ID to the blockedIds array
                guard let blockListDocument = querySnapshotBlockedUserBlockList.documents.first else {
                    return
                }
                
                let existingBeBlockedIds = blockListDocument["beBlockedBy"] as? [String] ?? []
                if !existingBeBlockedIds.contains(currentUserID) {
                    var updatedBeBlockedIds = existingBeBlockedIds
                    updatedBeBlockedIds.append(userIDToBlock)
                    
                    try await userBlockListCollection.document(blockListDocument.documentID).updateData(["beBlockedBy": updatedBeBlockedIds])
                }
            }
        } catch {
            throw error
        }
    }

   // Unblock
    func unblockOtherUser(forUserID userIDToUnblock: String) async throws {
        // Unblock (start receiving notifications + access to post/story + send messages + others can see your post)
            do {
                let userBlockListCollection = Firestore.firestore().collection("test_block")
                let currentUserID = "ao2PKDpap4Mq7M5cn3Nrc1Mvoa42" // Replace with the actual current user's ID
                
                // Use a Firestore query to check if the user has a block list
                let queryCurrentUserBlockList = userBlockListCollection.whereField("ownerId", isEqualTo: currentUserID)
                let queryBlockedUserBlockList = userBlockListCollection.whereField("ownerId", isEqualTo: userIDToUnblock)

                // Get the block list of the current user
                let querySnapshotCurrentUserBlockList = try await queryCurrentUserBlockList.getDocuments()
                let querySnapshotBlockedUserBlockList = try await queryBlockedUserBlockList.getDocuments()
                
                // If the block list exists, remove the user ID from the blockedIds array
                if let blockListDocument = querySnapshotCurrentUserBlockList.documents.first {
                    var existingBlockedIds = blockListDocument["blockedIds"] as? [String] ?? []
                    
                    if let indexToRemove = existingBlockedIds.firstIndex(of: userIDToUnblock) {
                        existingBlockedIds.remove(at: indexToRemove)
                        try await userBlockListCollection.document(blockListDocument.documentID).updateData(["blockedIds": existingBlockedIds])
                    }
                }
                
                // If the block list exists, remove the user ID from the blockedIds array
                if let beBlockListDocument = querySnapshotBlockedUserBlockList.documents.first {
                    var existingBeBlockedIds = beBlockListDocument["beBlockedBy"] as? [String] ?? []
                    
                    if let indexToRemove = existingBeBlockedIds.firstIndex(of: currentUserID) {
                        existingBeBlockedIds.remove(at: indexToRemove)
                        try await userBlockListCollection.document(beBlockListDocument.documentID).updateData(["beBlockedBy": existingBeBlockedIds])
                    }
                }
            } catch {
                throw error
        }
    }
    
    // Follow users
    func followOtherUser(forUserID userIDToFollow: String) async throws {
        do {
            let userFollowListCollection = Firestore.firestore().collection("test_follow")
            let currentUserID = "ao2PKDpap4Mq7M5cn3Nrc1Mvoa42" // Replace with the actual current user's ID
            
            let queryCurrentUserFollowList = userFollowListCollection.whereField("ownerId", isEqualTo: currentUserID)
            let queryFollowedUserFollowList = userFollowListCollection.whereField("ownerId", isEqualTo: userIDToFollow)
            
            // Get follow list of both users
            let querySnapshotCurrentUserFollowList = try await queryCurrentUserFollowList.getDocuments()
            let querySnapshotFollowedUserFollowList = try await queryFollowedUserFollowList.getDocuments()
            
            // If there are no matching documents, it means the user hasn't followed anyone, so create a new follow list
            if querySnapshotCurrentUserFollowList.isEmpty {
                let followListRef = userFollowListCollection.document()
                let followList = UserFollowList(id: followListRef.documentID, ownerId: currentUserID, followIds: [userIDToFollow], beFollowedBy: [])
                guard let encodedFollowList = try? Firestore.Encoder().encode(followList) else {
                    return
                }
                
                try await followListRef.setData(encodedFollowList)
            } else {
                // If the folllow list exists, add the user ID to the followIds array
                guard let followListDocument = querySnapshotCurrentUserFollowList.documents.first else {
                    return
                }
                
                let existingFollowedIds = followListDocument["followIds"] as? [String] ?? []
                if !existingFollowedIds.contains(userIDToFollow) {
                    var updatedFollowIds = existingFollowedIds
                    updatedFollowIds.append(userIDToFollow)
                    
                    try await userFollowListCollection.document(followListDocument.documentID).updateData(["followIds": updatedFollowIds])
                }
            }
            
            // If there are no matching documents, it means the user hasn't been followed by anyone, so create a new be follow list
            if querySnapshotFollowedUserFollowList.isEmpty {
                // Create a new block list
                let followListRef = userFollowListCollection.document()
                let followList = UserFollowList(id: followListRef.documentID, ownerId: userIDToFollow, followIds: [], beFollowedBy: [currentUserID])

                guard let encodedFollowList = try? Firestore.Encoder().encode(followList) else {
                    return
                }
                
                try await followListRef.setData(encodedFollowList)
            } else {
                // If the befollowed list exists, add the user ID to the blockedIds array
                guard let followListDocument = querySnapshotFollowedUserFollowList.documents.first else {
                    return
                }
                
                let existingBeFollowedIds = followListDocument["beFollowedBy"] as? [String] ?? []
                if !existingBeFollowedIds.contains(currentUserID) {
                    var updatedBeFollowedIds = existingBeFollowedIds
                    updatedBeFollowedIds.append(currentUserID)
                    
                    try await userFollowListCollection.document(followListDocument.documentID).updateData(["beFollowedBy": updatedBeFollowedIds])
                }
            }
        } catch {
            throw error
        }
    }

    // Unblock other user
    func unFollowOtherUser(forUserID userIDToUnFollow: String) async throws {
            do {
                let userFollowListCollection = Firestore.firestore().collection("test_follow")
                let currentUserID = "ao2PKDpap4Mq7M5cn3Nrc1Mvoa42" // Replace with the actual current user's ID
                
                // Use a Firestore query to check if the user has a block list
                let queryCurrentUserFollowList = userFollowListCollection.whereField("ownerId", isEqualTo: currentUserID)
                let queryFollowedUserFollowList = userFollowListCollection.whereField("ownerId", isEqualTo: userIDToUnFollow)

                // Get the block list of the current user
                let querySnapshotCurrentUserFollowList = try await queryCurrentUserFollowList.getDocuments()
                let querySnapshotFollowedUserFollowList = try await queryFollowedUserFollowList.getDocuments()
                
                // If the block list exists, remove the user ID from the blockedIds array
                if let followListDocument = querySnapshotCurrentUserFollowList.documents.first {
                    var existingBlockedIds = followListDocument["followIds"] as? [String] ?? []
                    
                    if let indexToRemove = existingBlockedIds.firstIndex(of: userIDToUnFollow) {
                        existingBlockedIds.remove(at: indexToRemove)
                        try await userFollowListCollection.document(followListDocument.documentID).updateData(["followIds": existingBlockedIds])
                    }
                }
                
                // If the followed list exists, remove the user ID from the follow array
                if let beFollowedListDocument = querySnapshotFollowedUserFollowList.documents.first {
                    var existingBeFollowedIds = beFollowedListDocument["beFollowedBy"] as? [String] ?? []
                    
                    if let indexToRemove = existingBeFollowedIds.firstIndex(of: currentUserID) {
                        existingBeFollowedIds.remove(at: indexToRemove)
                        try await userFollowListCollection.document(beFollowedListDocument.documentID).updateData(["beFollowedBy": existingBeFollowedIds])
                    }
                }
            } catch {
                throw error
        }
    }
    
    // restrict (not receiving notification + post/story + other can still see your posts)
    func restrictOtherUser(forUserID userIDToRestrict: String) async throws {
        do {
            let userRestrictListCollection = Firestore.firestore().collection("test_restrict")
            let currentUserID = "ao2PKDpap4Mq7M5cn3Nrc1Mvoa42" // Replace with the actual current user's ID
            
            // Use a Firestore query to check if the user has already restrict another user
            let queryCurrentUserRestrictList = userRestrictListCollection.whereField("ownerId", isEqualTo: currentUserID)
            
            // Get restrict list of both users
            let querySnapshotCurrentUserRestrictList = try await queryCurrentUserRestrictList.getDocuments()
            
            // If there are no matching documents, it means the user hasn't restricted anyone, so create a new restrict list
            if querySnapshotCurrentUserRestrictList.isEmpty {
                // Create a new restrict list
                let restrictListRef = userRestrictListCollection.document()
                let restrictList = UserRestrictList(id: restrictListRef.documentID, ownerId: currentUserID, restrictIds: [userIDToRestrict])
                
                guard let encodedRestrictList = try? Firestore.Encoder().encode(restrictList) else {
                    return
                }
                
                try await restrictListRef.setData(encodedRestrictList)
            } else {
                // If the restrict list exists, add the user ID to the restrictIds array
                guard let restrictListDocument = querySnapshotCurrentUserRestrictList.documents.first else {
                    return
                }
                
                let existingRestrictIds = restrictListDocument["restrictIds"] as? [String] ?? []
                if !existingRestrictIds.contains(userIDToRestrict) {
                    var updatedRestrictedIds = existingRestrictIds
                    updatedRestrictedIds.append(userIDToRestrict)
                    
                    try await userRestrictListCollection.document(restrictListDocument.documentID).updateData(["restrictIds": updatedRestrictedIds])
                }
            }
        } catch {
            throw error
        }
    }

   // Unrestrict
    func unRestrictOtherUser(forUserID userIDToUnRestrict: String) async throws {
            do {
                let userRestrictListCollection = Firestore.firestore().collection("test_restrict")
                let currentUserID = "ao2PKDpap4Mq7M5cn3Nrc1Mvoa42" // Replace with the actual current user's ID
                
                // Use a Firestore query to check if the user has a restrict list
                let queryCurrentUserRestrictList = userRestrictListCollection.whereField("ownerId", isEqualTo: currentUserID)

                // Get the restrict list of the current user
                let querySnapshotCurrentUserRestrictList = try await queryCurrentUserRestrictList.getDocuments()
                // If the restrict list exists, remove the user ID from the restrictIds array
                if let restrictListDocument = querySnapshotCurrentUserRestrictList.documents.first {
                    var existingRestrictedIds = restrictListDocument["restrictIds"] as? [String] ?? []
                    
                    if let indexToRemove = existingRestrictedIds.firstIndex(of: userIDToUnRestrict) {
                        existingRestrictedIds.remove(at: indexToRemove)
                        try await userRestrictListCollection.document(restrictListDocument.documentID).updateData(["restrictIds": existingRestrictedIds])
                    }
                }
            } catch {
                throw error
        }
    }
    
    // Get like count for current post
    @MainActor
    func getLikeCount(forPostID postID: String, completion: @escaping (Int)  -> Void) {
        likePostListenerRegistration = Firestore.firestore().collection("test_likes").whereField("postId", isEqualTo: postID).addSnapshotListener { [weak self] querySnapshot, error in
            guard self != nil else { return }
            
            if let error = error {
                print("Error fetching likes: \(error)")
                completion(0) // Return 0 when there's an error, and false for the boolean
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                completion(0) // Return 0 when there's an error, and false for the boolean
                return
            }

            completion(documents.count)
        }
    }
    
    // Check if user has like a post
    func isUserLikePost (forPostID postID: String, withUserId userId: String,completion: @escaping (Bool)  -> Void) {
        Firestore.firestore().collection("test_likes").whereField("postId", isEqualTo: postID).whereField("likerId", isEqualTo: userId).addSnapshotListener { [weak self] querySnapshot, error in
            guard self != nil else { return }
            
            if let error = error {
                print("Error fetching likes: \(error)")
                completion(false) // Return 0 when there's an error, and false for the boolean
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                completion(false) // Return 0 when there's an error, and false for the boolean
                return
            }
            
            let hasLikerId = documents.contains { document in
                let data = document.data()
                return data["likerId"] as? String == userId
            }
            completion(hasLikerId)
        }
    }
    
    // Get MIME type for images/video
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
