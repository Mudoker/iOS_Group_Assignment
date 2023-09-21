//
//  ChatUserModel.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 15/09/2023.
//

import Foundation

struct ChatUser : Identifiable{
    var id : String{uid}
    let uid, email : String
    init(data:[String : Any]){
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
    }
    
}
