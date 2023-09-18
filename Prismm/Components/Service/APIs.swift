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
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift


struct API_SERVICE {
    static func fetchUser(withUid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(withUid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchComment(withUid: String) async throws -> Comment {
        let snapshot = try await Firestore.firestore().collection("test_comments").document(withUid).getDocument()
        return try snapshot.data(as: Comment.self)
    }
    
    static func fetchYourPost(withUid: String) async throws -> [Post] {
        let snapshot = try await Firestore.firestore().collection("test_posts").whereField("owner", isEqualTo: withUid).getDocuments()
        return try snapshot.documents.compactMap({try $0.data(as: Post.self)})
    }
    
    static func fetchAPost(withUid: String) async throws -> Post {
        let snapshot = try await Firestore.firestore().collection("test_posts").document(withUid).getDocument()
        return try snapshot.data(as: Post.self)
    }
}
