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
import Firebase

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
        let snapshot = try await Firestore.firestore().collection("test_posts").whereField("owner", isEqualTo: userID).getDocuments()
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
    static func fetchCurrentUserData(withEmail userEmail: String) async throws -> UserSetting? {
        // Simulate fetching data with a delay
        guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
        guard let userSnapshot = try? await Firestore.firestore().collection("users").document(currentUserId).getDocument() else { return nil }
        
        if !userSnapshot.exists {
            do {
                let newUser = User(id: currentUserId, password: "password", username: userEmail)
                let encodedUser = try Firestore.Encoder().encode(newUser)
                try await Firestore.firestore().collection("users").document(currentUserId).setData(encodedUser)
            } catch {
                print("ERROR: Fail to add user data")
            }
        }
        
        //new: fetch setting data
        guard let userSettingsSnapshot = try? await Firestore.firestore().collection("settings").document(currentUserId).getDocument() else { return nil }
        
        if !userSettingsSnapshot.exists {
            do {
                let newSetting = UserSetting(id: currentUserId, darkModeEnabled: false, englishLanguageEnabled: true, faceIdEnabled: false, pushNotificationsEnabled: false, messageNotificationsEnabled: false) //new: create new setting data
                
                let encodedSetting = try Firestore.Encoder().encode(newSetting)
                
                try await Firestore.firestore().collection("settings").document(currentUserId).setData(encodedSetting)
            } catch {
                print("ERROR: Fail to add setting data")
            }
        } else {
            return try? userSettingsSnapshot.data(as: UserSetting.self)
        }
        return nil
    }
}
