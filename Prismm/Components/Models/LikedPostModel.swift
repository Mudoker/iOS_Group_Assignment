//
//  LikedPostModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 21/09/2023.
//

import Foundation
import Firebase

struct LikedPost: Identifiable, Codable {
    let id: String
    let likerId: String
    let postId: String
}
