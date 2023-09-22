//
//  LikedPostModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 21/09/2023.
//

import Foundation
import Firebase

struct UserFollowList: Identifiable, Codable {
    let id: String
    let ownerId: String
    let followIds: [String]
    let beFollowedBy: [String]
}
