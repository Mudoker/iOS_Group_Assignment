/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Apple Men
 Doan Huu Quoc (s3927776)
 Tran Vu Quang Anh (s3916566)
 Nguyen Dinh Viet (s3927291)
 Nguyen The Bao Ngoc (s3924436)
 
 Created  date: 09/09/2023
 Last modified: 09/09/2023
 Acknowledgement: None
 */

import Foundation

struct User: Identifiable, Codable, Equatable, Hashable {
    let id: String
    var username: String
    var account: String?
    
    var phoneNumber: String?
    var bio: String?
    var profileImageURL: String?
    var facebook: String?
    var linkedIn: String?
    var notifications: [String?]
    
    init(id: String, account: String) {
        self.id = id
        self.username = account.extractNameFromEmail()!
        self.account = account
        
        self.phoneNumber = ""
        self.bio = ""
        self.profileImageURL = ""
        self.facebook = ""
        self.linkedIn = ""
        self.notifications = []
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        // Compare the properties you want to consider for equality
        return lhs.id == rhs.id
    }
}


