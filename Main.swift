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
    @StateObject var authVM = AuthenticationViewModel()
    @StateObject var settingVM = SettingViewModel()
    @StateObject var homeVM = HomeViewModel()
    @StateObject var profileVM = ProfileViewModel()
    var body: some Scene {
        WindowGroup {
            //HomeView()
            HomeView(homeViewModel: homeVM, settingVM: settingVM)
                .onAppear{
                                    print(Auth.auth().currentUser?.uid ?? "Not sign in" )
                                }
        }
    }
    
    init(){
        FirebaseApp.configure()
    }
}
