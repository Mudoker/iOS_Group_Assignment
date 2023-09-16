//
//  PrismmApp.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

@main
struct PrismmApp: App {
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
    
    init(){
        FirebaseApp.configure()
    }
}
