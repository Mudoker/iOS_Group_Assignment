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
    var fullName: String
    var password: String
    var phoneNumber: String
    var bio: String?
    var profileImageURL: String?
    var facebookLink: String?
    var followers: [String] //
    var following: [String] //
    var posts: [String] //
    var favoritePost: [String] //
    var stories: [String] //
    var message: [String] //
    //var setting: Setting
    
    init(id: String, userName: String, password: String) {
        self.id = id
        self.username = userName
        self.fullName = userName + "1"
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
