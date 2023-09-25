//
//  AppManager.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 22/09/2023.
//

import Foundation

class AppManager: ObservableObject{
    @Published var isSignIn = false
    @Published var isChat = false
    init(isSignIn: Bool = false) {
        self.isSignIn = isSignIn
        self.isChat = false
    }
}
