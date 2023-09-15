//
//  PostModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation
import Firebase

struct Post: Identifiable, Codable {
    let id: String
    let owner: String
    var postCaption: String?
    var likers: [String?] = []
    var mediaURL: String?
    var mimeType: String?
    var date: Timestamp
    var postComment: [String?] = []
    var user: User?
    var unwrapLikers: [User?] = []
    var unwrapComments: [Comment?] = []
    
//    // Implement the == operator to compare Post instances for equality
//    static func == (lhs: Post, rhs: Post) -> Bool {
//        return lhs.id == rhs.id
//    }
//
//    // Implement the hash(into:) method for Hashable conformance
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
}
