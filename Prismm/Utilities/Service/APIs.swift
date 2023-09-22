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
}
