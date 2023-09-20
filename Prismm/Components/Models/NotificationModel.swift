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
import Firebase

struct AppNotification: Identifiable, Codable {
    let id: String
    let senderName: String
    let receiverId: String
    let messageContent: String
    let postLink: String
    let creationDate: Timestamp
    let category: NotificationCategory
    var isNotified: Bool
}

enum NotificationCategory: String, Codable {
    case follow
    case comment
    case react
    case mention
    case system
}
