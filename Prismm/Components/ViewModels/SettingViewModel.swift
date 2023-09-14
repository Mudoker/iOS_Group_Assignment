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
    @Published var isDarkMode = false{
        didSet{
            Task{
                await updateSettingData()
            }
        }
    }
    @Published var isFaceId = false{
        didSet{
            Task{
                await updateSettingData()
            }
        }
    }
    @Published var isPushNotification = false{
        didSet{
            Task{
                await updateSettingData()
            }
        }
    }
    @Published var isMessageNotification = false{
        didSet{
            Task{
                await updateSettingData()
            }
        }
    }
    @Published var language = "en"{
        didSet{
            Task{
                await updateSettingData()
            }
        }
    }
    
    //BE setting test
    let uid = "m52oyZNbCxVx5SsvFAEPwankeAP2" //user id will be set when login
    init(isDarkMode: Bool = false, isFaceId: Bool = false, isPushNotification: Bool = false, isMessageNotification: Bool = false, language: String = "en") {
        self.isDarkMode = isDarkMode
        self.isFaceId = isFaceId
        self.isPushNotification = isPushNotification
        self.isMessageNotification = isMessageNotification
        self.language = language
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
        let setting = Setting(id: self.uid, isDarkMode: self.isDarkMode, isEnglish: language == "en" ? true : false, isFaceId: self.isFaceId, isPushNotification: self.isPushNotification, isMessageNotification: self.isMessageNotification)
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
        
        

    }
}
