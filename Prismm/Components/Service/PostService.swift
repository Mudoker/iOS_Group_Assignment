////
////  UserService.swift
////  Prismm
////
////  Created by Nguyen Dinh Viet on 13/09/2023.
////
//
//import Foundation
//import Firebase
//
//struct PostService {
//    static func fetchComment(withUid: String) async throws -> Comment {
//        let snapshot = try await Firestore.firestore().collection("test_comments").document(withUid).getDocument()
//        return try snapshot.data(as: Comment.self)
//    }
//    
//    static func fetchAllComment(from: String) async throws -> [Comment] {
//        let snapshot = try await Firestore.firestore().collection("test_posts").getDocuments()
//        return try snapshot.documents.compactMap({try $0.data(as: Post.self)})
//    }
//}
