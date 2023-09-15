//
//  CommentModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation
import Firebase

struct Comment: Identifiable, Codable {
    let id: String
    let content: String
    let commentor: String
//    let date: Timestamp
}
