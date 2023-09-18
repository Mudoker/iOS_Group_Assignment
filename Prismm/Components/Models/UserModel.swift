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

struct User: Identifiable, Codable {
    let id: String
    var username: String
    var fullName: String?
    var password: String
    var phoneNumber: String?
    var bio: String?
    var profileImageURL: String?
    var facebookLink: String?
    
    //add gmail link and linked in link
    var gmailLink: String?
    var ldLink: String?
    
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
