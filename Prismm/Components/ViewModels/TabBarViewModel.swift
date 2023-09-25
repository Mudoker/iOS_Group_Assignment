//
//  TabBarViewModel.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 25/09/2023.
//

import Foundation

class TabBarViewModel: ObservableObject {
    @Published var currentUser = User(id: "", account: "")
    @Published var userSetting = UserSetting(id: "", darkModeEnabled: false, language: "en", faceIdEnabled: false, pushNotificationsEnabled: false, messageNotificationsEnabled: false)
}
