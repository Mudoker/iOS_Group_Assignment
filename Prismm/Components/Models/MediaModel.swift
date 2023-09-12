//
//  MediaModel.swift
//  Prismm
//
//  Created by quoc on 12/09/2023.
//

import Foundation

struct Post_Image: Identifiable, Decodable {
    let mediaUrl: String

    var id: String {
        return NSUUID().uuidString
    }
}

struct Post_Video: Identifiable, Decodable {
    let mediaUrl: String

    var id: String {
        return NSUUID().uuidString
    }
}
