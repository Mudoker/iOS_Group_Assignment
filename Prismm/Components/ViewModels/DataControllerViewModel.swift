//
//  DataControllerViewModel.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 21/09/2023.
//

import Foundation

class DataControllerViewModel: ObservableObject{
    @Published var currentUser: User? = User(id: "test", password: "testpassword", username: "testUsername")
    @Published var userSettings:UserSetting? = UserSetting(id: "test", darkModeEnabled: false, language: "en", faceIdEnabled: true, pushNotificationsEnabled: false, messageNotificationsEnabled: false)
    
    
    @MainActor
    func setCurrentData() async{
        currentUser = try? await APIService.fetchCurrentUserData()
        userSettings = try? await APIService.fetchCurrentSettingData()
    }
}

