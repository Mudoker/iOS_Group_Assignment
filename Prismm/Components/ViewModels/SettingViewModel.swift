//
//  LoginViewModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//


import SwiftUI
import Foundation

class SettingViewModel: ObservableObject {
    @Published var isDarkMode = true
    @Published var isFaceId = false
    @Published var isPushNotification = false
    @Published var isMessageNotification = false
    @Published var language = "en"
    @Published var isAccountSettingSheetPresentedIphone = false
    @Published var isAccountSettingSheetPresentedIpad = false
    @Published var selectedLanguage = ["English, Vietnamese"]
    @Published var isShowingSignOutAlert = false
    @Published var isSignOut = false
    @Published var isChangePasswordCurrentPassword = ""
    @Published var isChangePasswordNewPassword = ""
    @Published var isChangePasswordPasswordVisible = false
    @Published var isSecuritySettingChange = false // Track changes in fields
    @Published var isEnabledFaceId = false
    
    @Published var isChangeProfile = false
    @Published var isChangeProfileUsername: String = ""
    @Published var isChangeProfilePhoneNumber: String = ""
    @Published var isChangeProfileFB: String = ""
    @Published var isChangeProfileGmail: String = ""
    @Published var isChangeProfileLD: String = ""
    
    // Responsive
    @Published var proxySize: CGSize = CGSize(width: 0, height: 0)
    var cornerRadiusSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 40 : proxySize.width / 50
    }

    var accountSettingSizeHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 4 : proxySize.height / 8
    }

    var accountSettingImageSizeWidth: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 8 : proxySize.width / 12
    }

    var accountSettingUsernameFont: Font {
        UIDevice.current.userInterfaceIdiom == .phone ? .title3 : .title
    }

    var accountSettingEmailFont: Font {
        .body
    }

    var contentFont: Font {
        UIDevice.current.userInterfaceIdiom == .phone ? .body : .title3
    }

    var imageSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 18 : proxySize.width / 28
    }

    var signOutText: Font {
        UIDevice.current.userInterfaceIdiom == .phone ? .title3 : .title
    }
    
    func isSecuritySettingChange(currentPassword: String, newPassword: String, isBioMetric: Bool) -> Bool {
        if currentPassword != "" || newPassword != "" || isBioMetric != isEnabledFaceId {
            return true
        }
        return false
    }
    func isProfileSettingChange(username: String, phoneNumber: String, fb: String, gmail: String, ld: String) -> Bool {
        if username != isChangeProfileUsername ||
           phoneNumber != isChangeProfilePhoneNumber ||
           fb != isChangeProfileFB ||
           gmail != isChangeProfileGmail ||
           ld != isChangeProfileLD {
            return true // At least one setting has changed
        }
        return false // No settings have changed
    }

    func isValidProfileURL(_ url: String, platform: String) -> Bool {
        switch platform {
        case "fb":
            return url.hasPrefix("https://www.facebook.com/")
        case "ld":
            return url.hasPrefix("https://www.linkedin.com/")
        case "gm":
            let gmailRegex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9._%+-]+@gmail\\.com")
            let range = NSRange(location: 0, length: url.utf16.count)
            return gmailRegex.firstMatch(in: url, options: [], range: range) != nil
        default:
            return false // Invalid platform
        }
    }
}
