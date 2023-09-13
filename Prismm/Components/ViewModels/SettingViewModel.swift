//
//  SettingViewModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 11/09/2023.
//

import SwiftUI
import Foundation

class SettingViewModel: ObservableObject{
    @Published var isDarkMode = false
    @Published var isFaceId = false
    @Published var isPushNotification = false
    @Published var isMessageNotification = false
    @Published var language = "en"
    
    //Responsive
    var cornerRadiusSize: CGFloat = 0
    var accountSettingSizeHeight: CGFloat = 0
    var accountSettingImageSizeWidth: CGFloat = 0
    var accountSettingUsernameFont: Font = .title3
    var accountSettingEmailFont: Font = .body
    var contentFont: Font = .body
    var imageSize: CGFloat = 0
    var signOutText: Font = .body
    
    
}
