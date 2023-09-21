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
    //@StateObject var settingVM = SettingViewModel()
    @StateObject var homeVM = HomeViewModel()
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var dataControllerVM = DataControllerViewModel()
    
    var body: some Scene {
        WindowGroup {
            //HomeView()
            if Auth.auth().currentUser == nil{
                Login(authVM: authVM, homeVM: homeVM, profileVM: profileVM)
                    .environmentObject(dataControllerVM)
            }else{
                TabBar(authVM: authVM, homeVM: homeVM, profileVM: profileVM)
                    .environmentObject(dataControllerVM)
                    .onAppear{
                        Task{
                            await dataControllerVM.setCurrentData()
                        }
                        
                    }
                    
            }
                
        }
        
        
    }
    
    init(){
        FirebaseApp.configure()
    }
}
