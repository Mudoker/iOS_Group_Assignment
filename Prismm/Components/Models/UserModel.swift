//
//  User.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation

struct UserModel {
    let userID: String
    var username: String
    var fullName: String
    var password: String
    var phoneNumber: String
    var bio: String?
    var profileImageURL: URL?
    var facebookLink: URL?
    var followers: [UUID]
    var following: [UUID]
    var posts: [UUID]
    var favoritePost: [UUID]
    var stories: [UUID]
    var message: [UUID]
    var setting: SettingModel
}
