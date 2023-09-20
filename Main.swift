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

@main
struct PrismmApp: App {
    @StateObject var authVM = AuthenticationViewModel()
    @StateObject var settingVM = SettingViewModel()
    @StateObject var homeVM = HomeViewModel()
    @StateObject var profileVM = ProfileViewModel()
    
    var body: some Scene {
        WindowGroup {
            //HomeView()
            if Auth.auth().currentUser == nil{
                Login(authVM: authVM, settingVM: settingVM, homeVM: homeVM, profileVM: profileVM)
            }else{
                TabBar(authVM: authVM, settingVM: settingVM, homeVM: homeVM, profileVM: profileVM)
                    .onAppear{
                        Task{
                            authVM.currentUser = try? await APIService.fetchCurrentUserData()
                            authVM.userSettings = try? await APIService.fetchCurrentSettingData()
                            print(authVM.userSettings?.darkModeEnabled)
                        }
                        
                    }
            }
                
        }
        
    }
    
    init(){
        FirebaseApp.configure()
    }
}
