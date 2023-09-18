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

class ProfileViewModel: ObservableObject {
//    let user: User
    @Published var posts = [Post]()
    
//    init(user: User) {
//        self.user = user
//        Task {
//            try await fetchUserPosts()
//        }
//    }
    
    @MainActor
    func fetchUserPosts() async throws {
        self.posts = try await API_SERVICE.fetchYourPost(withUid: "3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        
//        for i in 0..<posts.count {
//            posts[i].user = self.user
//        }
    }
}
