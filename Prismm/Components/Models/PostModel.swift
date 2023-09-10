//
//  PostModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation

struct PostModel {
    let id: UUID
    let Date: Date
    let op: UUID
    var likers: [UUID]
    var postImage: String
    var postcaption: String
    var postComment: [CommentModel]
}
