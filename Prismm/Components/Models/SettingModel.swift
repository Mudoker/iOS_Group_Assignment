//
//  SettingModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation

struct Setting: Codable {
    let id: String
    var isDarkMode: Bool
    var isEnglish: Bool
    var isFaceId: Bool
    var isPushNotification: Bool
    var isMessageNotification: Bool
}
