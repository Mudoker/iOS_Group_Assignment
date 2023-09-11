//
//  LoginViewModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation
import LocalAuthentication
import SwiftUI
import Firebase

class AuthenticationViewModel: ObservableObject {
    @Published var isUnlocked = false
    @Published var isDarkMode = false
    @Published var userToken: String {
        didSet {
            UserDefaults.standard.set(userToken, forKey: "userToken")
        }
    }
    
    // set user token for bio metric login
    init() {
        self.userToken = UserDefaults.standard.string(forKey: "userToken") ?? ""
    }
    
    // Responsive
    @Published var titleFont: CGFloat = 40
    @Published var logoImageSize: CGFloat = 0
    @Published var captionFont: Font = .caption
    @Published var textFieldTitleFont: Font = .body
    @Published var textFieldSizeHeight: CGFloat = 0
    @Published var textFieldCorner: CGFloat = 0
    @Published var textFieldBorderWidth: CGFloat = 2.5
    @Published var faceIdImageSize: CGFloat = 0
    @Published var imagePaddingVertical: CGFloat = 16
    @Published var loginButtonSizeHeight: CGFloat = 60
    @Published var conentFont: Font = .body
    @Published var loginTextFont: Font = .title3
    @Published var textFieldPlaceHolderFont: Font = .body
    @Published var isLoading = false
    @Published var loginStatusMessage = ""
    @Published var errorMessage = ""
    // Validate username
    func validateUsername(_ username: String) -> Bool{
        isUnlocked = true
        return true
    }
    
    // Validate password
    func validatePassword(_ password: String) -> Bool{
        isUnlocked = true
        return true
    }
    
    // Validate username (check for duplicates)
    func validateUsernameSignUp(_ username: String) -> Bool {
        return true
    }
    
    // Validate password (at least 8 characters + not contating special symbols)
    func validatePasswordSignUp(_ password: String) -> Bool {
        if password.count >= 8 && !password.containsSpecialSymbols() {
            return false
        } else {
            return true
        }
    }
    
    func isMatchPassword(currentPassword: String, reEnteredPassword: String) -> Bool {
        if currentPassword == reEnteredPassword {
            return true
        } else {
            return false
        }
    }
    // log in
    func login(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){
            res, err in
            if let err = err {
                print("Failed to login user", err)
                self.loginStatusMessage = "Fail to create user \(err)"
            }
            
            print("log in thanh cong : \(res?.user.uid ?? "" )")
            self.loginStatusMessage = "log in thanh cong: \(res?.user.uid ?? "")"
        }
    }
    // create new account
    func createAccount(withEmail email: String, password  : String){
        Auth.auth().createUser(withEmail : email, password: password){
            res, err in
            if let err = err {
                print("Failed to create user", err)
                self.errorMessage = "Fail to create user \(err)"
            }
            
            print("Dk thanh cong : \(res?.user.uid ?? "" )")
            self.loginStatusMessage = "Dk thanh cong: \(res?.user.uid ?? "")"
        }
    }
    
    // Fetch userdata from Firebase
    func fetchUserData() {
        // Simulate fetching data with a delay
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
        }
    }
    
    // FaceId login
    func bioMetricAuthenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login with FaceId") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Biometric authentication was successful
                        self.isUnlocked = true
                    } else {
                        // Biometric authentication failed or was canceled
                        if let error = authenticationError {
                            // Handle the specific error
                            print("Biometric authentication failed: \(error.localizedDescription)")
                            
                        } else {
                            // Handle the case where authentication was canceled or failed without an error
                            print("Biometric authentication failed.")
                        }
                    }
                }
            }
        } else {
            // Handle the case where biometric authentication is not available or supported
            if let error = error {
                // Handle the error
                print("Biometric authentication not available: \(error.localizedDescription)")
            } else {
                // Handle the case where biometric authentication is not supported
                print("Biometric authentication not supported on this device.")
            }
        }
    }
}
