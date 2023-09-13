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
    @StateObject var viewModel = AuthenticationViewModel()
    var body: some Scene {
        WindowGroup {
            Test_AddComment()
                .environmentObject(viewModel)
        }
    }
    
    init(){
        FirebaseApp.configure()
    }
}
