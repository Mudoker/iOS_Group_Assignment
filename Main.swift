//
//  PrismmApp.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import UserNotifications
import FirebaseAuth

@main
struct PrismmApp: App {
    @StateObject var manager = AppManager(isSignIn:  Auth.auth().currentUser != nil ? true : false )
    @StateObject var notiVM = NotificationViewModel()
    @StateObject var tabVM = TabBarViewModel()
    
    var body: some Scene {
        WindowGroup {
            if !manager.isSignIn {
                Login()
                    .environmentObject(manager)
                    
            } else {
                TabBar()
                    .environmentObject(manager)
                    .environmentObject(tabVM)
            }
        }
        
    }
    
    // Configure firebase
    init(){
        FirebaseApp.configure()
        
    }
}

