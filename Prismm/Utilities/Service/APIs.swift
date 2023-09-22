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
    // Fetch user with id
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
}
