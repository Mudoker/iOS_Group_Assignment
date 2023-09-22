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

struct Post: Identifiable, Codable {
    let id: String
    var ownerID: String
    var caption: String?

    var mediaURL: String?
    var mediaMimeType: String?
    var tag: [String] = []
    var creationDate: Timestamp
    var isAllowComment: Bool
    var unwrappedOwner: User?

}
