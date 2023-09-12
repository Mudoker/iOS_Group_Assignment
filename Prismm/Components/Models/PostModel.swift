//
//  PostModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation

struct Post: Identifiable, Codable {
    let id: String
    let owner: String
    let postCaption: String
    var likers: [String]
    let postImage: String
    let Date: Date
    var user: User?
    //var postComment: [String]
}
