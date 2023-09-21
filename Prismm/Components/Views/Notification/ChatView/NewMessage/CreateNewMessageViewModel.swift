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
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        Firestore.firestore().collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    do{
                        let userData = try snapshot.data(as: User.self)
                        
                        if userData.id != Auth.auth().currentUser?.uid {
                            self.users.append(userData)
                        }
                    }catch{
                        print("Fail to get data")
                    }
                    
                })
                print("oke r do")
            }
    }
}
