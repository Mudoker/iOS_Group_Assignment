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
    //@Published var isEnabledFaceId = false
    
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
    
    func checkSecuritySettingChange() -> Bool {
        if isChangePasswordCurrentPassword != "" || isChangePasswordNewPassword != ""{
            return true
        }
        return false
    }
    
    func isProfileSettingChange() -> Bool {
        if isChangeProfileUsername != "" ||
            isChangeProfilePhoneNumber != "" ||
            isChangeProfileFB != "" ||
            isChangeProfileGmail != "" ||
            isChangeProfileLD != "" {
           isChangeProfilePhoneNumber != "" ||
           isChangeProfileFB != "" ||
           isChangeProfileGmail != "" ||
           isChangeProfileLD != "" {
            return true // At least one setting has changed
        }
        return false // No settings have changed
    }
    
    func isValidProfileURL(_ url: String, platform: String) -> Bool {
        //if the link is not written
        if url.isEmpty{
            return true
        }
        
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
    
    func updateSettingData(uid: String) async{
        guard let snapshot = try? await Firestore.firestore().collection("settings").document(uid).getDocument() else {return}
        let setting = Setting(id: uid, isDarkMode: self.isDarkMode, isEnglish: self.language == "en" ? true : false, isFaceId: self.isFaceId, isPushNotification: self.isPushNotification, isMessageNotification: self.isMessageNotification)
        do{
            let encodedsetting = try Firestore.Encoder().encode(setting)
            
            if !snapshot.exists {
                try await Firestore.firestore().collection("settings").document(uid).setData(encodedsetting)
            }else{
                try await Firestore.firestore().collection("settings").document(uid).updateData(encodedsetting)
                print("Updated succcessfully")
            }
        }catch{
            print("ERROR: Fail to add user data")
        }
    }
    
    func updateUserData(uid: String) async{
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        
        do{
            var user = try snapshot.data(as: User.self)
            
            if(user.username != isChangeProfileUsername){
                user.username = isChangeProfileUsername
            }
            if(user.phoneNumber != isChangeProfilePhoneNumber){
                user.phoneNumber = isChangeProfilePhoneNumber
            }
            if(user.facebookLink != isChangeProfileFB){
                user.facebookLink = isChangeProfileFB
            }
            if(user.gmailLink != isChangeProfileGmail){
                user.gmailLink = isChangeProfileGmail
            }
            if(user.ldLink != isChangeProfileLD){
                user.ldLink = isChangeProfileLD
            }
            
            let encodedUser = try Firestore.Encoder().encode(user)
            
            if !snapshot.exists {
                try await Firestore.firestore().collection("users").document(uid).setData(encodedUser)
            }else{
                try await Firestore.firestore().collection("users").document(uid).updateData(encodedUser)
                print("Updated succcessfully2")
            }
        }catch{
            print("ERROR: Update failed")
        }
    }
    
    //not done
    func updatePassword(uid: String) async {
        
    }
}
