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

struct APIService {
    
    
    static func fetchUser(withUserID userID: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchComment(withCommentID commentID: String) async throws -> Comment {
        let snapshot = try await Firestore.firestore().collection("test_comments").document(commentID).getDocument()
        return try snapshot.data(as: Comment.self)
    }
    
    static func fetchPostsOwned(byUserID userID: String) async throws -> [Post] {
        let snapshot = try await Firestore.firestore().collection("test_posts").whereField("ownerID", isEqualTo: userID).getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: Post.self) })
    }
    
    static func fetchPost(withPostID postID: String) async throws -> Post {
        let snapshot = try await Firestore.firestore().collection("test_posts").document(postID).getDocument()
        return try snapshot.data(as: Post.self)
    }
    
    static func fetchNotificationsForUser(withUserID userID: String) async throws -> [AppNotification] {
        let snapshot = try await Firestore.firestore().collection("test_noti").whereField("owner", isEqualTo: userID).getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: AppNotification.self) })
    }
    
    // Fetch userdata from Firebase
    static func fetchCurrentUserData() async throws -> User? {
        // Simulate fetching data with a delay
        guard let currentUser = Auth.auth().currentUser else { return nil }
        guard let userSnapshot = try? await Firestore.firestore().collection("users").document(currentUser.uid).getDocument() else { return nil }
        
        if !userSnapshot.exists {
            do {
                let newUser = User(id: currentUser.uid, account: currentUser.email!)
                
                let encodedUser = try Firestore.Encoder().encode(newUser)
                try await Firestore.firestore().collection("users").document(currentUser.uid).setData(encodedUser)
                
                return newUser
            } catch {
                print("ERROR: Fail to add user data")
            }
        }else {
            return try? userSnapshot.data(as: User.self)
        }
        
        
        return nil
    }
    
    static func fetchCurrentSettingData() async throws -> UserSetting? {
        print("fetch setting")
        guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
        //new: fetch setting data
        guard let userSettingsSnapshot = try? await Firestore.firestore().collection("test_settings").document(currentUserId).getDocument() else { return nil }
        
        print("got snapshot")
        if !userSettingsSnapshot.exists {
            do {
                let newSetting = UserSetting(id: currentUserId, darkModeEnabled: false, language: "en", faceIdEnabled: false, pushNotificationsEnabled: false, messageNotificationsEnabled: false) //new: create new setting data
                
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
                        try await userBlockListCollection.document(currentUserID).updateData(["beBlockedBy": existingBeBlockedIds])
                    }
                    
                }
            } catch {
                throw error
        }
    }
    
    // Follow users
    static func followOtherUser(forUserID userIDToFollow: String) async throws {
     
    }

   // Unblock
    static func unFollowOtherUser(forUserID userIDToUnFollow: String) async throws {
    
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
                
                let existingRestrictedIds = snapshotCurrentUserRestrictList["restrictIDs"] as? [String] ?? []
                if !existingRestrictedIds.contains(userIDToRestrict) {
                    var updatedRestrictedIds = existingRestrictedIds
                    updatedRestrictedIds.append(userIDToRestrict)
                    
                    try await userRestrictListCollection.document(currentUserID).updateData(["restrictIDs": updatedRestrictedIds])
                }
            }
            
            
        } catch {
            throw error
        }
    }

   // Unblock
    static func unRestrictOtherUser(forUserID userIDToUnRestrict: String) async throws {
        do {
            let userRestrictListCollection = Firestore.firestore().collection("test_restrict")
            let currentUserID =  Auth.auth().currentUser?.uid ?? "ZMSfvuGAW9OOSfM4mLVG10kAJJk2"
            
            // Use a Firestore query to check if the user has already blocked another user
            let snapshotCurrentUserRestrictList = try await userRestrictListCollection.document(currentUserID).getDocument()

            // If there are no matching documents, it means the user hasn't blocked anyone, so create a new block list
            if !snapshotCurrentUserRestrictList.exists {

                var existingRestrictIds = snapshotCurrentUserRestrictList["restrictIDs"] as? [String] ?? []
                
                if let indexToRemove = existingRestrictIds.firstIndex(of: userIDToUnRestrict) {
                    existingRestrictIds.remove(at: indexToRemove)
                    try await userRestrictListCollection.document(currentUserID).updateData(["restrictIDs": existingRestrictIds])
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
    
    static func createMediaToFirebase(newPostSelectedMedia: NSURL) async throws -> String {
        print("Uploading media")
        
        let selectedMedia = newPostSelectedMedia

        print(selectedMedia)
        
        do {
            let mediaData = try Data(contentsOf: selectedMedia as URL)
            print("Completed converting data")
            
            if mediaData.count > 25_000_000 {
                print("Selected file too large: \(mediaData)")
                return ""
            }
            
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
    
    static func mimeType(for data: Data) -> String {
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
                
                try await Firestore.firestore().collection("test_block").document(currentUser.uid).setData(encodedList)
                print("got new user block list")
                return newUserRestrictList
            } catch {
                print("ERROR: Fail to add block list data")
            }
        } else {
            print("got database setting")
            return try? snapshot.data(as: UserRestrictList.self)
        }
        return nil
    }
}
