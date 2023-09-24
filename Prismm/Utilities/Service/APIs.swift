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
 
 Created  date: 13/09/2023
 Last modified: 13/09/2023
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

// Communicating with firebase
struct APIService {
    
    
    static func fetchUser(withUserID userID: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    // Fetch comment with id
    static func fetchComment(withCommentID commentID: String) async throws -> Comment {
        let snapshot = try await Firestore.firestore().collection("test_comments").document(commentID).getDocument()
        return try snapshot.data(as: Comment.self)
    }
    
    // Fetch all posts of user
    static func fetchPostsOwned(byUserID userID: String) async throws -> [Post] {
        let snapshot = try await Firestore.firestore().collection("test_posts").whereField("ownerID", isEqualTo: userID).getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: Post.self) })
    }
    
    // Fetch a post
    static func fetchPost(withPostID postID: String) async throws -> Post {
        let snapshot = try await Firestore.firestore().collection("test_posts").document(postID).getDocument()
        return try snapshot.data(as: Post.self)
    }

    // Fetch current user data from Firebase
    static func fetchCurrentUserData() async throws -> User? {
        // Get the current authenticated user
        guard let currentUser = Auth.auth().currentUser else { return nil }
        
        // Fetch user data from Firestore
        guard let userSnapshot = try? await Firestore.firestore().collection("users").document(currentUser.uid).getDocument() else { return nil }
        
        // Check if the user data exists
        if !userSnapshot.exists {
            do {
                // Create new user data if it not exist
                let newUser = User(id: currentUser.uid, account: currentUser.email!)
                
                let encodedUser = try Firestore.Encoder().encode(newUser)
                try await Firestore.firestore().collection("users").document(currentUser.uid).setData(encodedUser)
                
                return newUser
            } catch {
                print("ERROR: Fail to add user data")
            }
        } else {
            return try? userSnapshot.data(as: User.self)
        }
        
        return nil
    }
    
    // Fetch settings of current user
    static func fetchCurrentSettingData() async throws -> UserSetting? {
        // Get the current user id
        guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
        
        // Fetch user setting data from Firestore
        guard let userSettingsSnapshot = try? await Firestore.firestore().collection("test_settings").document(currentUserId).getDocument() else { return nil }
        
        if !userSettingsSnapshot.exists {
            do {
                // Create a new setting if it not exist
                let newSetting = UserSetting(id: currentUserId, darkModeEnabled: false, language: "en", faceIdEnabled: false, pushNotificationsEnabled: false, messageNotificationsEnabled: false)
                
                let encodedSetting = try Firestore.Encoder().encode(newSetting)
                
                try await Firestore.firestore().collection("test_settings").document(currentUserId).setData(encodedSetting)
                
                print("got new setting")
                return newSetting
            } catch {
                print("ERROR: Fail to add setting data")
            }
        } else {
            print("got database setting")
            return try? userSettingsSnapshot.data(as: UserSetting.self)
        }
        return nil
    }
    
    // Block (not receiving notification + post/story + message + other cannot see your post)
    static func blockOtherUser(forUserID userIDToBlock: String) async throws {
        do {
            let userBlockListCollection = Firestore.firestore().collection("test_block")
            let currentUserID =  Auth.auth().currentUser?.uid ?? "ZMSfvuGAW9OOSfM4mLVG10kAJJk2"
            
            // Use a Firestore query to check if the user has already blocked another user
            let snapshotCurrentUserBlockList = try await userBlockListCollection.document(currentUserID).getDocument()
            let snapshotBlockedUserBlockList = try await userBlockListCollection.document(userIDToBlock).getDocument()
            

            // If there are no matching documents, it means the user hasn't blocked anyone, so create a new block list
            if !snapshotCurrentUserBlockList.exists {
                // Create a new block list
                let blockListRef = userBlockListCollection.document(currentUserID)
                let blockList = UserBlockList(blockedIds: [userIDToBlock], beBlockedBy: [])
                
                guard let encodedBlockList = try? Firestore.Encoder().encode(blockList) else {
                    return
                }
                
                try await blockListRef.setData(encodedBlockList)
            } else {
                // If the block list exists, add the user ID to the blockedIds array
                
                let existingBlockedIds = snapshotCurrentUserBlockList["blockedIds"] as? [String] ?? []
                if !existingBlockedIds.contains(userIDToBlock) {
                    var updatedBlockedIds = existingBlockedIds
                    updatedBlockedIds.append(userIDToBlock)
                    
                    try await userBlockListCollection.document(currentUserID).updateData(["blockedIds": updatedBlockedIds])
                }
            }
            
            // If there are no matching documents, it means the user hasn't blocked anyone, so create a new block list
            if !snapshotBlockedUserBlockList.exists {
                // Create a new block list
                let blockListRef = userBlockListCollection.document(userIDToBlock)
                let blockList = UserBlockList(blockedIds: [], beBlockedBy: [currentUserID])
                
                guard let encodedBlockList = try? Firestore.Encoder().encode(blockList) else {
                    return
                }
                
                try await blockListRef.setData(encodedBlockList)
            } else {
                // If the block list exists, add the user ID to the blockedIds array

                
                let existingBeBlockedIds = snapshotBlockedUserBlockList["beBlockedBy"] as? [String] ?? []
                if !existingBeBlockedIds.contains(currentUserID) {
                    var updatedBeBlockedIds = existingBeBlockedIds
                    updatedBeBlockedIds.append(userIDToBlock)
                    
                    try await userBlockListCollection.document(userIDToBlock).updateData(["beBlockedBy": updatedBeBlockedIds])
                }
            }
        } catch {
            throw error
        }
    }

   // Unblock
    static func unblockOtherUser(forUserID userIDToUnblock: String) async throws {
        // Unblock (start receiving notifications + access to post/story + send messages + others can see your post)
            do {
                let userBlockListCollection = Firestore.firestore().collection("test_block")
                let currentUserID =  Auth.auth().currentUser?.uid ?? "ZMSfvuGAW9OOSfM4mLVG10kAJJk2"
                

                // Get the block list of the current user
                let snapshotCurrentUserBlockList = try await userBlockListCollection.document(currentUserID).getDocument()
                let snapshotBlockedUserBlockList = try await userBlockListCollection.document(userIDToUnblock).getDocument()
                

                // If the block list exists, remove the user ID from the blockedIds array
                if snapshotCurrentUserBlockList.exists {

                    var existingBlockedIds = snapshotCurrentUserBlockList["blockedIds"] as? [String] ?? []
                    
                    if let indexToRemove = existingBlockedIds.firstIndex(of: userIDToUnblock) {
                        existingBlockedIds.remove(at: indexToRemove)
                        try await userBlockListCollection.document(currentUserID).updateData(["blockedIds": existingBlockedIds])
                    }
                    
                }
                
                
                // If the block list exists, remove the user ID from the blockedIds array
                
                if snapshotBlockedUserBlockList.exists {
                    var existingBeBlockedIds = snapshotBlockedUserBlockList["beBlockedBy"] as? [String] ?? []
                    if let indexToRemove = existingBeBlockedIds.firstIndex(of: currentUserID) {
                        existingBeBlockedIds.remove(at: indexToRemove)
                        try await userBlockListCollection.document(userIDToUnblock).updateData(["beBlockedBy": existingBeBlockedIds])
                    }
                    
                }
            } catch {
                throw error
        }
    }
    
    // Follow users
    static func followOtherUser(forUserID userIDToFollow: String) async throws {
        do {
            let userFollowListCollection = Firestore.firestore().collection("test_follow")
            let currentUserID =  Auth.auth().currentUser?.uid ?? "ZMSfvuGAW9OOSfM4mLVG10kAJJk2"
            
            // Use a Firestore query to check if the user has already blocked another user
            let snapshotCurrentUserFollowList = try await userFollowListCollection.document(currentUserID).getDocument()
            let snapshotTargetUserFollowList = try await userFollowListCollection.document(userIDToFollow).getDocument()
            

            // If there are no matching documents, it means the user hasn't blocked anyone, so create a new block list
            if !snapshotCurrentUserFollowList.exists {
                // Create a new block list
                let followListRef = userFollowListCollection.document(currentUserID)
                let followList = UserFollowList(followIds: [userIDToFollow], beFollowedBy: [])
                
                guard let encodedFollowList = try? Firestore.Encoder().encode(followList) else {
                    return
                }
                
                try await followListRef.setData(encodedFollowList)
            } else {
                // If the block list exists, add the user ID to the blockedIds array
                
                let existingFollowIds = snapshotCurrentUserFollowList["followIds"] as? [String] ?? []
                if !existingFollowIds.contains(userIDToFollow) {
                    var updatedFollowIds = existingFollowIds
                    updatedFollowIds.append(userIDToFollow)
                    
                    try await userFollowListCollection.document(currentUserID).updateData(["followIds": updatedFollowIds])
                }
            }
            
            // If there are no matching documents, it means the user hasn't blocked anyone, so create a new block list
            if !snapshotTargetUserFollowList.exists {
                // Create a new block list
                let followListRef = userFollowListCollection.document(userIDToFollow)
                let followList = UserFollowList(followIds: [], beFollowedBy: [currentUserID])
                
                guard let encodedFollowList = try? Firestore.Encoder().encode(followList) else {
                    return
                }
                
                try await followListRef.setData(encodedFollowList)
            } else {
                // If the block list exists, add the user ID to the blockedIds array

                
                let existingBeFollowedIds = snapshotTargetUserFollowList["beFollowedBy"] as? [String] ?? []
                if !existingBeFollowedIds.contains(currentUserID) {
                    var updatedBeFollowIds = existingBeFollowedIds
                    updatedBeFollowIds.append(currentUserID)
                    
                    try await userFollowListCollection.document(userIDToFollow).updateData(["beFollowedBy": updatedBeFollowIds])
                }
            }
        } catch {
            throw error
        }
    }

   // Unblock
    static func unfollowOtherUser(forUserID userIDToUnFollow: String) async throws {
        // Unblock (start receiving notifications + access to post/story + send messages + others can see your post)
            do {
                let userFollowListCollection = Firestore.firestore().collection("test_follow")
                let currentUserID =  Auth.auth().currentUser?.uid ?? "ZMSfvuGAW9OOSfM4mLVG10kAJJk2"
                

                // Get the block list of the current user
                let snapshotCurrentUserFollowList = try await userFollowListCollection.document(currentUserID).getDocument()
                let snapshotTargetUserFollowList = try await userFollowListCollection.document(userIDToUnFollow).getDocument()
                

                // If the block list exists, remove the user ID from the blockedIds array
                if snapshotCurrentUserFollowList.exists {

                    var existingFollowedIds = snapshotCurrentUserFollowList["followIds"] as? [String] ?? []
                    
                    if let indexToRemove = existingFollowedIds.firstIndex(of: userIDToUnFollow) {
                        existingFollowedIds.remove(at: indexToRemove)
                        try await userFollowListCollection.document(currentUserID).updateData(["followIds": existingFollowedIds])
                    }
                    
                }
                
                // If the block list exists, remove the user ID from the blockedIds array
                
                if snapshotTargetUserFollowList.exists {
                    var existingFollowedIds = snapshotTargetUserFollowList["beFollowedBy"] as? [String] ?? []
                    if let indexToRemove = existingFollowedIds.firstIndex(of: currentUserID) {
                        existingFollowedIds.remove(at: indexToRemove)
                        try await userFollowListCollection.document(userIDToUnFollow).updateData(["beFollowedBy": existingFollowedIds])
                    }
                    
                }
            } catch {
                throw error
        }
    }
    
    @MainActor
    static func fetchCurrentUserFollowList() async throws-> UserFollowList? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        let snapshot = try await Firestore.firestore().collection("test_follow").document(currentUser.uid).getDocument()


        print("got snapshot")
        if !snapshot.exists{
            do {
                let newUserFollowList = UserFollowList(followIds: [], beFollowedBy: [])
                
                let encodedList = try Firestore.Encoder().encode(newUserFollowList)
                
                try await Firestore.firestore().collection("test_follow").document(currentUser.uid).setData(encodedList)
                print("got new user block list")
                return newUserFollowList
            } catch {
                print("ERROR: Fail to add block list data")
            }
        } else {
            print("got database setting")
            return try? snapshot.data(as: UserFollowList.self)
        }
        return nil
        
    }
    // restrict (not receiving notification + post/story + other can still see your posts)
    static func restrictOtherUser(forUserID userIDToRestrict: String) async throws {
        do {
            let userRestrictListCollection = Firestore.firestore().collection("test_restrict")
            let currentUserID =  Auth.auth().currentUser?.uid ?? "ZMSfvuGAW9OOSfM4mLVG10kAJJk2"
            
            // Use a Firestore query to check if the user has already blocked another user
            let snapshotCurrentUserRestrictList = try await userRestrictListCollection.document(currentUserID).getDocument()

            // If there are no matching documents, it means the user hasn't blocked anyone, so create a new block list
            if !snapshotCurrentUserRestrictList.exists {
                // Create a new block list
                let restrictistRef = userRestrictListCollection.document(currentUserID)
                let restictList = UserRestrictList(restrictIds: [userIDToRestrict])
                
                guard let encodedBlockList = try? Firestore.Encoder().encode(restictList) else {
                    return
                }
                
                try await restrictistRef.setData(encodedBlockList)
            } else {
                // If the block list exists, add the user ID to the blockedIds array
                
                let existingRestrictedIds = snapshotCurrentUserRestrictList["restrictIds"] as? [String] ?? []
                if !existingRestrictedIds.contains(userIDToRestrict) {
                    var updatedRestrictedIds = existingRestrictedIds
                    updatedRestrictedIds.append(userIDToRestrict)
                    
                    try await userRestrictListCollection.document(currentUserID).updateData(["restrictIds": updatedRestrictedIds])
                }
            }
            
            
        } catch {
            throw error
        }
    }

   // Unblock
    static func unRestrictOtherUser(forUserID userIDToUnRestrict: String) async throws {
        do {
            print("Already delete")
            let userRestrictListCollection = Firestore.firestore().collection("test_restrict")
            let currentUserID =  Auth.auth().currentUser?.uid ?? "ZMSfvuGAW9OOSfM4mLVG10kAJJk2"
            print(currentUserID)
            // Use a Firestore query to check if the user has already blocked another user
            let snapshotCurrentUserRestrictList = try await userRestrictListCollection.document(currentUserID).getDocument()

            // If there are no matching documents, it means the user hasn't blocked anyone, so create a new block list
            if snapshotCurrentUserRestrictList.exists {

                var existingRestrictIds = snapshotCurrentUserRestrictList["restrictIds"] as? [String] ?? []
                if let indexToRemove = existingRestrictIds.firstIndex(of: userIDToUnRestrict) {
                    existingRestrictIds.remove(at: indexToRemove)
                    try await userRestrictListCollection.document(currentUserID).updateData(["restrictIds": existingRestrictIds])
                    print("removed!!!!!!")
                }
                
            }
            
        
        } catch {
            throw error
    }
   
    }
    
    //upload the media data to database storage
    static func uploadMediaToFireBase(withMedia data: Data) async throws -> String? {
        let fileName = UUID().uuidString
        let mediaRef = Storage.storage().reference().child("/media/\(fileName)")
        let metaData  = StorageMetadata()
        metaData.contentType = self.mimeType(for: data)
        
        do {
            let _ = try await mediaRef.putDataAsync(data, metadata: metaData)
            let downloadURL = try await mediaRef.downloadURL()
            return downloadURL.absoluteString
        } catch {
            print("Media upload failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Upload media to firebase
    static func createMediaToFirebase(newPostSelectedMedia: NSURL) async throws -> String {
        print("Uploading media")
        
        let selectedMedia = newPostSelectedMedia
        
        do {
            // Convert to data
            let mediaData = try Data(contentsOf: selectedMedia as URL)
            print("Completed converting data")
            
            // Limit media size to 25MB
            if mediaData.count > 25_000_000 {
                print("Selected file too large: \(mediaData)")
                return ""
            }
            
            // Upload media data to Firebase and get the media URL
            guard let mediaUrl = try await APIService.uploadMediaToFireBase(withMedia: mediaData) else {
                return ""
            }
            
            print("Uploaded media data to Firebase")
            return mediaUrl
        } catch {
            print("Failed to upload post: \(error)")
            return ""
        }
    }
    
    
    @MainActor
    static func fetchAllUsers() async throws -> [User]{
        
        do {
            let querySnapshot = try await Firestore.firestore().collection("users").getDocuments()
            
            if querySnapshot.isEmpty {
                print("No documents")
                return []
            }
            
            
            var users: [User] = []
            
            // Iterate and convert to User objects
            for queryDocumentSnapshot in querySnapshot.documents {
                if let post = try? queryDocumentSnapshot.data(as: User.self) {
                    users.append(post)
                }
            }
            
            return users
            
            
        }catch{
            print("Error fetching posts: \(error)")
            throw error
        }
    }

    
    // Get MIME type of media data
    static func mimeType(for data: Data) -> String {
        var b: UInt8 = 0
        
        // get the first byte
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
        case 0x46:
            return "text/plain"
        case 0x52:
            // Check for common video file formats
            if data.count >= 12 && data[8...11] == Data("AVI ".utf8) {
                return "video/avi"
            }
        case 0x00:
            // Check for MP4 format
            if data.count >= 12 && data[4...7] == Data("ftyp".utf8) {
                return "video/mp4"
            }
            
            // Check for MOV format
            if data.count >= 4 && data[4...7] == Data("ftyp".utf8) && data[8...11] == Data("qt  ".utf8) {
                return "video/quicktime"
            }
        case 0x1A:
            // Check for MKV
            if data.count >= 4 && data[1...3] == Data("webm".utf8) {
                return "video/webm"
            }
        default:
            return "application/octet-stream"
        }
        return "application/octet-stream"
    }
    
    @MainActor
    static func fetchCurrentUserBlockList() async throws-> UserBlockList? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        let snapshot = try await Firestore.firestore().collection("test_block").document(currentUser.uid).getDocument()


        print("got snapshot")
        if !snapshot.exists{
            do {
                let newUserBlockList = UserBlockList(blockedIds: [], beBlockedBy: [])
                
                let encodedList = try Firestore.Encoder().encode(newUserBlockList)
                
                try await Firestore.firestore().collection("test_block").document(currentUser.uid).setData(encodedList)
                print("got new user block list")
                return newUserBlockList
            } catch {
                print("ERROR: Fail to add block list data")
            }
        } else {
            print("got database setting")
            return try? snapshot.data(as: UserBlockList.self)
        }
        return nil
        
    }
    
    
    @MainActor
    static func fetchCurrentUserRestrictedList() async throws -> UserRestrictList? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        let snapshot = try await Firestore.firestore().collection("test_restrict").document(currentUser.uid).getDocument()
        print("got snapshot")
        if !snapshot.exists{
            do {
                let newUserRestrictList = UserRestrictList(restrictIds: [])
                let encodedList = try Firestore.Encoder().encode(newUserRestrictList)
                try await Firestore.firestore().collection("test_restrict").document(currentUser.uid).setData(encodedList)
                print("got new user restrict list")
                return newUserRestrictList
            } catch {
                print("ERROR: Fail to add block list data")
            }
        } else {
            return try? snapshot.data(as: UserRestrictList.self)
        }
        return nil
    }
    
    @MainActor
    static func fetchUserRestrictedList(withUserId receiverId: String) async throws -> UserRestrictList? {
        let snapshot = try await Firestore.firestore().collection("test_restrict").document(receiverId).getDocument()

        if !snapshot.exists{
            do {
                let newUserRestrictList = UserRestrictList(restrictIds: [])
                let encodedList = try Firestore.Encoder().encode(newUserRestrictList)
                print("got new user restrict list")
                return newUserRestrictList
            } catch {
                print("ERROR: Fail to add block list data")
            }
        } else {
            print(try? snapshot.data(as: UserRestrictList.self))
            return try? snapshot.data(as: UserRestrictList.self)
            
        }
        return nil
    }
}
