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

  Created  date: 14/09/2023
  Last modified: 14/09/2023
  Acknowledgement: None
*/

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import FirebaseStorage
import MobileCoreServices
import AVFoundation
import FirebaseFirestoreSwift

class ProfileViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var hasStoryHightlight = false
    @Published var isShowAllUserPost = true
    
    @Published var proxySize: CGSize = CGSize(width: 0, height: 0)
    
    var avatarSize : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 4.3 : proxySize.width / 4.3
    }
    
    @MainActor
    func fetchUserPosts() async throws {
        self.posts = try await APIService.fetchPostsOwned(byUserID: "3WBgDcMgEQfodIbaXWTBHvtjYCl2")
    }
}
