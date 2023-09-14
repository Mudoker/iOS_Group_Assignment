//
//  ProfileViewModel.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 14/09/2023.
//

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
        self.posts = try await UserService.fetchYourPost(withUid: "3WBgDcMgEQfodIbaXWTBHvtjYCl2")
        
//        for i in 0..<posts.count {
//            posts[i].user = self.user
//        }
    }
}
