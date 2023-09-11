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
import FirebaseFirestoreSwift

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var isUnlocked = false
    @Published var isDarkMode = false
    @Published var userToken: String {
        didSet {
            UserDefaults.standard.set(userToken, forKey: "userToken")
        }
    }
    
    @Published var userSession : FirebaseAuth.User?
    @Published var currentUser : User?
    
    // set user token for bio metric login
    init() {
        self.userToken = UserDefaults.standard.string(forKey: "userToken") ?? ""
        //self.userSession = Auth.auth().currentUser
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
    
    func signUp (withEmail email: String, password: String, fullName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, userName: fullName, password: password)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUserData()
        } catch {
            print("Fail to log in \(error.localizedDescription)")
        }
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
    
    // Fetch userdata from Firebase
    func fetchUserData() async {
        // Simulate fetching data with a delay
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
//        isLoading = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.isLoading = false
//        }
        print("Current user: : \(self.currentUser?.fullName)")
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
