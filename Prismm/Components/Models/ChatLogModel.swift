//
//  ChatLogModel.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 15/09/2023.
//

import Foundation

struct ChatMessageModel: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, text: String
    let isSeen : Bool
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.isSeen = data[FirebaseConstants.isSeen] as? Bool ?? false
    }
}
