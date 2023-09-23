//
//  LikedPostModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 21/09/2023.
//

import Foundation
import Firebase

struct UserBlockList: Codable {
    let blockedIds: [String]
    let beBlockedBy: [String]
}
