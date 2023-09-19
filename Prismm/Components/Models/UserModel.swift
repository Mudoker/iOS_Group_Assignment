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
    var facebook: String?
    var gmail: String?
    var linkedIn: String?
    
    var followers: [String?] // User IDs of followers
    var following: [String?] // User IDs of users being followed
    var posts: [String?] // IDs of posts made by the user
    var favoritePosts: [String?] // IDs of favorite posts
    var stories: [String?] // IDs of user stories
    var messages: [String?] // IDs of messages
    var notifications: [String?]
    var restrictedList: [String?] // User IDs in restricted list
    var blockList: [String?] // User IDs in block list
    var restrictedByList: [String?] // User IDs in restricted list
    var blockByList: [String?] // User IDs in block list
    init(id: String, password: String, username: String) {
        self.id = id
        self.username = username
        self.fullName = ""
        self.password = password
        self.phoneNumber = ""
        self.bio = ""
        self.profileImageURL = ""
        self.facebook = ""
        self.gmail = ""
        self.linkedIn = ""
        self.followers = []
        self.following = []
        self.posts = []
        self.favoritePosts = []
        self.stories = []
        self.messages = []
        self.notifications = []
        self.restrictedList = []
        self.blockList = []
    }
}

