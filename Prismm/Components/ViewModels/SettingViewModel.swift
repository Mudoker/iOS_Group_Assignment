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
import Foundation
import LocalAuthentication
import SwiftUI
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
    @Published var isBlockListSheetPresentedOniPhone = false
    @Published var isRestrictedListSheetPresentedOniPhone = false
    @Published var isSignOutAlertPresented = false
    @Published var isSigningOut = false
    
    @Published var avatarSelectedMedia: NSURL? = nil
    
    @Published var changePasswordCurrentPassword = ""
    @Published var changePasswordNewPassword = ""
    @Published var isChangePasswordVisible = false
    @Published var hasSecuritySettingChanged = false
    @Published var hasProfileSettingChanged = false
    @Published var newProfileUsername: String = ""
    @Published var newProfileBio: String = ""
    @Published var newProfilePhoneNumber: String = ""
    @Published var newProfileFacebook: String = ""
    @Published var newProfileGmail: String = ""
    @Published var newProfileLinkedIn: String = ""
    
    @Published var isUpdateProfile = false
    
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
        !newProfileFacebook.isEmpty || !newProfileGmail.isEmpty || !newProfileLinkedIn.isEmpty || !newProfileBio.isEmpty
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
    func updateProfile() async throws -> User? {
        // get current user id
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        // Get the user document from Firestore
        guard let userSnapshot = try? await Firestore.firestore().collection("users").document(userID).getDocument() else { return nil}
        
        do {
            // Decode user data
            var updatedUser = try userSnapshot.data(as: User.self)
            
            if !newProfileUsername.isEmpty {
                updatedUser.username = newProfileUsername
            }
            
            if !newProfileBio.isEmpty{
                updatedUser.bio = newProfileBio
            }
            
            if !newProfilePhoneNumber.isEmpty {
                updatedUser.phoneNumber = newProfilePhoneNumber
            }
            
            if !newProfileFacebook.isEmpty {
                updatedUser.facebook = newProfileFacebook
            }
            
            if !newProfileLinkedIn.isEmpty {
                updatedUser.linkedIn = newProfileLinkedIn
            }
            
            if avatarSelectedMedia != NSURL(string: updatedUser.profileImageURL ?? "") {
                print("update avt")
                let mediaURL = try await APIService.createMediaToFirebase(newPostSelectedMedia: avatarSelectedMedia!)
                updatedUser.profileImageURL = mediaURL
                
            }
            
            let encodedUser = try Firestore.Encoder().encode(updatedUser)
            
            // Create or update user data in Firestore
            
                try await Firestore.firestore().collection("users").document(userID).setData(encodedUser)
            
          
            
            return updatedUser
        } catch {
            print("ERROR: Failed to update user data.")
            return nil
        }
    }
    
    @MainActor
    func checkBiometrics() async  -> Bool {
        let context = LAContext()
        var biometricError: NSError?

        // Check if biometrics is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &biometricError) {
            // Authenticate using biometrics
            let localizedReason = "Authenticate with Biometrics"

            let success = await withCheckedContinuation { (continuation: CheckedContinuation<Bool, Never>) in
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            // Successful biometric authentication
                            continuation.resume(returning: true)
                        } else {
                            // Handle biometric authentication failure
                            if let error = authenticationError {
                                print("Biometric auth failed: \(error.localizedDescription)")
                            } else {
                                print("Biometric auth failed.")
                            }
                            continuation.resume(returning: false)
                        }
                    }
                }
            }

            return success
        } else {
            // Biometrics not available or supported
            if let error = biometricError {
                print("Biometrics not available: \(error.localizedDescription)")
            } else {
                print("Biometrics not supported on this device.")
            }
            return false
        }
    }
    
    func resetField(){
        newProfileUsername = ""
        newProfilePhoneNumber = ""
        newProfileFacebook = ""
        newProfileLinkedIn = ""
    }
}
