//
//  SettingViewModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 11/09/2023.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class SettingViewModel: ObservableObject{
    //New: update setting data on change of in app setting
    @Published var isDarkMode = false
    @Published var isFaceId = false
    @Published var isPushNotification = false
    @Published var isMessageNotification = false
    @Published var language = "en"
    
//    {
//        didSet{
//            Task{
//                await updateSettingData()
//            }
//        }
//    }
    
    
    
    //BE setting test
    @Published var  uid : String = "m52oyZNbCxVx5SsvFAEPwankeAP2"//hard code the data need to consider about the data flow from beginning
    
    func setSetting(currentSetting: Setting) {

        self.uid = currentSetting.id
        self.isDarkMode = currentSetting.isDarkMode
        self.isFaceId = currentSetting.isFaceId
        self.isPushNotification = currentSetting.isPushNotification
        self.isMessageNotification = currentSetting.isMessageNotification
        self.language = currentSetting.isEnglish ? "en" : "vi"
        
    }
    
    
    //Responsive
    var cornerRadiusSize: CGFloat = 0
    var accountSettingSizeHeight: CGFloat = 0
    var accountSettingImageSizeWidth: CGFloat = 0
    var accountSettingUsernameFont: Font = .title3
    var accountSettingEmailFont: Font = .body
    var contentFont: Font = .body
    var imageSize: CGFloat = 0
    var signOutText: Font = .body
    
    func updateSettingData() async{
        guard let snapshot = try? await Firestore.firestore().collection("settings").document(uid).getDocument() else {return}
        let setting = Setting(id: self.uid, isDarkMode: self.isDarkMode, isEnglish: self.language == "en" ? true : false, isFaceId: self.isFaceId, isPushNotification: self.isPushNotification, isMessageNotification: self.isMessageNotification)
        do{
            let encodedsetting = try Firestore.Encoder().encode(setting)
            
            if !snapshot.exists {
                try await Firestore.firestore().collection("settings").document(uid).setData(encodedsetting)
            }else{
                try await Firestore.firestore().collection("settings").document(uid).updateData(encodedsetting)
            }
        }catch{
            print("ERROR: Fail to add user data")
         }
        
        
        print("Updated succcessfully")
    }
}
