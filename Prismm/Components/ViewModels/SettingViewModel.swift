/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Apple Men
 Doan Huu Quoc (s3927776)
 Tran Vu Quang Anh (s3916566)
 Nguyen Dinh Viet (s3927291)
 Nguyen The Bao Ngoc (s3924436)
 
 Created  date: 09/09/2023
 Last modified: 09/09/2023
 Acknowledgement: None
 */

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class SettingViewModel: ObservableObject {
    @Published var isDarkModeEnabled = false
    @Published var isFaceIdEnabled = false
    @Published var isPushNotificationEnabled = false
    @Published var isMessageNotificationEnabled = false
    @Published var selectedLanguage = "en"
    @Published var isAccountSettingSheetPresentedOniPhone = false
    @Published var isAccountSettingSheetPresentedOniPad = false
    @Published var isSignOutAlertPresented = false
    @Published var isSigningOut = false
    @Published var changePasswordCurrentPassword = ""
    @Published var changePasswordNewPassword = ""
    @Published var isChangePasswordVisible = false
    @Published var hasSecuritySettingChanged = false
    @Published var hasProfileSettingChanged = false
    @Published var newProfileUsername: String = ""
    @Published var newProfilePhoneNumber: String = ""
    @Published var newProfileFacebook: String = ""
    @Published var newProfileGmail: String = ""
    @Published var newProfileLinkedIn: String = ""
    
    // Responsive
    @Published var proxySize: CGSize = CGSize(width: 0, height: 0)
    var cornerRadius: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 40 : proxySize.width / 50
    }
    
    var accountSettingHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 4 : proxySize.height / 8
    }
    
    var accountSettingImageWidth: CGFloat {
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
    
    var iconSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 18 : proxySize.width / 28
    }
    
    var signOutButtonTextFont: Font {
        UIDevice.current.userInterfaceIdiom == .phone ? .title3 : .title
    }
    
    func checkSecuritySettingChange() -> Bool {
        if changePasswordCurrentPassword != "" || changePasswordNewPassword != ""{
            return true
        }
        return false
    }
    
    func isProfileSettingChange() -> Bool {
        if !newProfileUsername.isEmpty ||
            !newProfilePhoneNumber.isEmpty ||
            !newProfileFacebook.isEmpty ||
            !newProfileGmail.isEmpty ||
            !newProfileLinkedIn.isEmpty {
            return true // At least one setting has changed
        }
        return false // No settings have changed
    }
    
    func isValidURL(_ profileURL: String, forPlatform platform: String) -> Bool {
        // Return false for empty profile URLs
        guard !profileURL.isEmpty else {
            return false
        }
        
        switch platform {
        case "fb":
            return profileURL.hasPrefix("https://www.facebook.com/")
        case "ld":
            return profileURL.hasPrefix("https://www.linkedin.com/")
        case "gm":
            let gmailRegex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9._%+-]+@gmail\\.com")
            let range = NSRange(location: 0, length: profileURL.utf16.count)
            return gmailRegex.firstMatch(in: profileURL, options: [], range: range) != nil
        default:
            return false // Invalid platform
        }
    }
    
    func updateSettings(forUserID userID: String) async {
        guard let settingsSnapshot = try? await Firestore.firestore().collection("settings").document(userID).getDocument() else {
            return
        }
        
        let userSettings = UserSetting(
            id: userID,
            darkModeEnabled: self.isDarkModeEnabled,
            englishLanguageEnabled: self.selectedLanguage == "en",
            faceIdEnabled: self.isFaceIdEnabled,
            pushNotificationsEnabled: self.isPushNotificationEnabled,
            messageNotificationsEnabled: self.isMessageNotificationEnabled
        )
        
        do {
            let encodedSettings = try Firestore.Encoder().encode(userSettings)
            
            if !settingsSnapshot.exists {
                try await Firestore.firestore().collection("settings").document(userID).setData(encodedSettings)
            } else {
                try await Firestore.firestore().collection("settings").document(userID).updateData(encodedSettings)
                print("Settings updated successfully")
            }
        } catch {
            print("ERROR: Failed to update user settings")
        }
    }
    
    
    func updateProfile(forUserID uid: String) async {
        guard let userSnapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        
        do {
            var updatedUser = try userSnapshot.data(as: User.self)
            
            if updatedUser.username != newProfileUsername {
                updatedUser.username = newProfileUsername
            }
            
            if updatedUser.phoneNumber != newProfilePhoneNumber {
                updatedUser.phoneNumber = newProfilePhoneNumber
            }
            
            if updatedUser.facebook != newProfileFacebook {
                updatedUser.facebook = newProfileFacebook
            }
            
            if updatedUser.gmail != newProfileGmail {
                updatedUser.gmail = newProfileGmail
            }
            
            if updatedUser.linkedIn != newProfileLinkedIn {
                updatedUser.linkedIn = newProfileLinkedIn
            }
            
            let encodedUser = try Firestore.Encoder().encode(updatedUser)
            
            if !userSnapshot.exists {
                try await Firestore.firestore().collection("users").document(uid).setData(encodedUser)
            } else {
                try await Firestore.firestore().collection("users").document(uid).updateData(encodedUser)
                print("User data updated successfully.")
            }
        } catch {
            print("ERROR: Failed to update user data.")
        }
    }
}

