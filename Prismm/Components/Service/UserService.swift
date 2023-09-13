//
//  UserService.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 13/09/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

struct UserService {
    static func fetchUser(withUid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(withUid).getDocument()
        return try snapshot.data(as: User.self)
    }
}
