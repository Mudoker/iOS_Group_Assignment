import Foundation
import Firebase

struct Notification: Identifiable, Codable {
    let id: String
    let senderName: String
    let receiver: String
    let message: String
    let time: Timestamp
    let category: NotificationCategory
}

enum NotificationCategory: String, Codable {
    case follow
    case comment
    case react
    case mention
    case message
    case system
    case status
}
