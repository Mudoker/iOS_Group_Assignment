//
//  LoginViewModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation
import LocalAuthentication

class AuthenticationViewModel: ObservableObject {
    @Published var isUnlocked = false
    @Published var isDarkMode = false
    
    // Validate username
    func validateUsername() -> Bool{
        return true
    }
    
    // Validate password
    func validatePassword() -> Bool{
        return true
    }
    
    // Validate password (at least 8 characters + not contating special symbols)
    func validatePassword(_ password: String) -> Bool {
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
    
    // FaceId login
    func bioMetricAuthenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Account Autofill") { success, authenticationError in
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
