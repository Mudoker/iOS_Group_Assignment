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
    // State control
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
    
    func setValue(setting: UserSetting) {
        self.isDarkModeEnabled = setting.darkModeEnabled
        self.isFaceIdEnabled = setting.faceIdEnabled
        self.isPushNotificationEnabled = setting.pushNotificationsEnabled
        self.isMessageNotificationEnabled = setting.messageNotificationsEnabled
        self.selectedLanguage = setting.language
        self.isAccountSettingSheetPresentedOniPhone = false
        self.isAccountSettingSheetPresentedOniPad = false
        self.isSignOutAlertPresented = false
        self.isSigningOut = false
        self.changePasswordCurrentPassword = ""
        self.changePasswordNewPassword = ""
        self.isChangePasswordVisible = false
        self.hasSecuritySettingChanged = false
        self.hasProfileSettingChanged = false
        self.newProfileUsername = ""
        self.newProfilePhoneNumber = ""
        self.newProfileFacebook = ""
        self.newProfileGmail = ""
        self.newProfileLinkedIn = ""
    }
    
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
    
    // Check for security setting chang
    func checkSecuritySettingChange() -> Bool {
        return !changePasswordCurrentPassword.isEmpty || !changePasswordNewPassword.isEmpty
    }
    
    // Check for profile setting change
    func isProfileSettingChange() -> Bool {
        return !newProfileUsername.isEmpty || !newProfilePhoneNumber.isEmpty ||
        !newProfileFacebook.isEmpty || !newProfileGmail.isEmpty || !newProfileLinkedIn.isEmpty
    }
    
    // Update user settings
    func updateSettings(userSetting: UserSetting) async {
        // get current user id
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        // Check if id is empty
        if userID == ""{
            return
        }
        
        // Get settings document from Firestore
        guard let settingsSnapshot = try? await Firestore.firestore().collection("test_settings").document(userID).getDocument() else {
            return
        }
        
        // Update settings
        do {
            let encodedSettings = try Firestore.Encoder().encode(userSetting)
            
            // Create or update settings data in Firestore
            if !settingsSnapshot.exists {
                try await Firestore.firestore().collection("test_settings").document(userID).setData(encodedSettings)
            } else {
                try await Firestore.firestore().collection("test_settings").document(userID).updateData(encodedSettings)
                print("Settings updated successfully to \(userID)")
            }
        } catch {
            print("ERROR: Failed to update user settings") // cannot find
        }
    }
    
    // update user information
    func updateProfile() async {
        // get current user id
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        // Get the user document from Firestore
        guard let userSnapshot = try? await Firestore.firestore().collection("users").document(userID).getDocument() else { return }
        
        do {
            // Decode user data
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
            
            if updatedUser.linkedIn != newProfileLinkedIn {
                updatedUser.linkedIn = newProfileLinkedIn
            }
            
            let encodedUser = try Firestore.Encoder().encode(updatedUser)
            
            // Create or update user data in Firestore
            if !userSnapshot.exists {
                try await Firestore.firestore().collection("users").document(userID).setData(encodedUser)
            } else {
                try await Firestore.firestore().collection("users").document(userID).updateData(encodedUser)
                print("User data updated successfully to \(userID)")
            }
        } catch {
            print("ERROR: Failed to update user data.")
        }
    }
}
