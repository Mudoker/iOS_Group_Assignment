//
//  PrismmApp.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore : Firestore
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage() // Corrected line
        self.firestore = Firestore.firestore() 
        
        super.init()
    }
}

@main
struct PrismmApp: App {
//    init() {
//        FirebaseApp.configure()
//    }
    var body: some Scene {
        WindowGroup {
            Login()
        }
    }
}

