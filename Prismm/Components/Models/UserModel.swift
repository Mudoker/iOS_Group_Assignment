//
//  User.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var username: String
    var fullName: String?
    var password: String
    var phoneNumber: String?
    var bio: String?
    var profileImageURL: String?
    var facebookLink: String?
    var followers: [String?] //
    var following: [String?] //
    var posts: [String?] //
    var favoritePost: [String?] //
    var stories: [String?] //
    var message: [String?] //
    //var setting: Setting
    
    init(id: String, password: String, username: String) {
        self.id = id
        self.username = username
        self.fullName = ""
        self.password = password
        self.phoneNumber = ""
        self.bio = ""
        self.profileImageURL = ""
        self.facebookLink = ""
        self.followers = []
        self.following = []
        self.posts = []
        self.favoritePost = []
        self.stories = []
        self.message = []
    }
}
