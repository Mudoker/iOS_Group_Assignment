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
    @Published var posts = [Post]()
    @Published var hasStoryHightlight = false
    @Published var isShowAllUserPost = true
    @MainActor
    func fetchUserPosts() async throws {
        self.posts = try await APIService.fetchPostsOwned(byUserID: "3WBgDcMgEQfodIbaXWTBHvtjYCl2")
    }
}
