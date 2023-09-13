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
    let postCaption: String
    var likers: [String]
    let mediaURL: String?
    let mimeType: String?
    let date: Timestamp
    var user: User?
    //var postComment: [String]
}
