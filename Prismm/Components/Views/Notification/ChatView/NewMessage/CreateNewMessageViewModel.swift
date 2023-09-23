//
//  CreateNewMessageViewModel.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 15/09/2023.
//

import Foundation
import Firebase

class CreateNewMessageViewModel: ObservableObject {
    
    @Published var users = [User]()
    @Published var errorMessage = "hi"

    
    @MainActor
    func fetchUsers() async {
        Task{
            users = try await APIService.fetchAllUsers()
        }
    }
    
}
