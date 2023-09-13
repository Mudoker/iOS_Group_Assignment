//
//  StoryModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation
import Firebase

struct Story {
    let id: String
    let date: Timestamp
    var status: Bool
    var source: String
    let poster: [String]
    var likers: [String?]
    var unwrapPoster: User?
    var unwrapLikers: [User?]
}
