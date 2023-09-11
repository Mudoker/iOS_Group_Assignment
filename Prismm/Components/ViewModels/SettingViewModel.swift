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
}
