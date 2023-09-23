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

struct Story: Identifiable, Codable {
    let id: String
    let creationDate: Timestamp
    var isActive: Bool
    
    var mediaURL: String?
    var mediaMimeType: String?
    
    let ownerId: String
    var unwrappedOwner: User?
}
