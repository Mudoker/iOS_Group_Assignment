//
//  MediaModel.swift
//  Prismm
//
//  Created by quoc on 12/09/2023.
//

import Foundation

struct Media: Identifiable, Decodable {
    let mediaUrl: String
    let mimeType: String

    var id: String {
        return NSUUID().uuidString
    }
}

