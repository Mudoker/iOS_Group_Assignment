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
import FirebaseFirestoreSwift
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

protocol SignUpFormProtocol{
    var formIsValid: Bool{get}
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var hasLoginError = false
    @Published var hasSignUpError = false
    @Published var isAlertPresent = false
    @Published var isDeviceUnlocked = false
    @Published var isGoogleUnlocked = false
    @Published var isBiometricUnlocked = false
    @Published var userEmail = ""
    @Published var isPasswordResetRequested = false
    @Published var isSignUpMode = false
    @Published var isPasswordValid = false
    @Published var isReenteredPasswordValid = false
    @Published var isUserNameValid = false
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var userSettings: UserSetting?
    @Published var isFetchingData = false
    @Published var userToken: String {
        didSet {
            UserDefaults.standard.set(userToken, forKey: "userToken")
        }
    }
    
    // Responsive
    @Published var proxySize: CGSize = CGSize(width: 0, height: 0)
    
    var titleFontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 40 : 60
    }
    
    var logoImageSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width/2.2 : proxySize.width/2.8
    }
    
    var captionFont: Font {
        .caption
    }
    
    var textFieldTitleFont: Font {
        .body
    }
    
    var textFieldSizeHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width/7 : proxySize.width/9
    }
    
    var textFieldCornerRadius: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width/50 : proxySize.width/60
    }
    
    var textFieldBorderWidth: CGFloat {
        2.5
    }
    
    var faceIdImageSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width/10 : proxySize.width/12
    }
    
    var imageVerticalPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 16 : 30
    }
    
    var loginButtonHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? textFieldSizeHeight : textFieldSizeHeight
    }
    
    var conentFont: Font {
        UIDevice.current.userInterfaceIdiom == .phone ? .body : .title2
    }
    
    var loginTextFont: Font {
        UIDevice.current.userInterfaceIdiom == .phone ? .title3 : .title
    }
    
    var textFieldPlaceHolderFont: Font {
        UIDevice.current.userInterfaceIdiom == .phone ? .body : .largeTitle
    }
    
    // set user token for bio metric login
    init() {
        self.userToken = UserDefaults.standard.string(forKey: "userToken") ?? ""
    }
    
    func createNewUser(withEmail email: String, password: String) async throws {
        do {
            let authSnapshot = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = authSnapshot.user
            
            // Create user data
            let newUser = User(id: authSnapshot.user.uid, password: password, username: email)
            let encodedUser = try Firestore.Encoder().encode(newUser)
            
            // Create initial user settings data
            let userSettings = UserSetting(id: authSnapshot.user.uid, darkModeEnabled: false, englishLanguageEnabled: true, faceIdEnabled: false, pushNotificationsEnabled: false, messageNotificationsEnabled: false)
            let encodedSettings = try Firestore.Encoder().encode(userSettings)
            
            // Save user and settings data to Firestore
            try await Firestore.firestore().collection("users").document(newUser.id).setData(encodedUser)
            try await Firestore.firestore().collection("settings").document(newUser.id).setData(encodedSettings)
        } catch {
            hasSignUpError = true
            print("Error during sign-up: \(error.localizedDescription)")
        }
    }
    
    func resetUserPassword(withEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updateUserPassword(to password: String) async throws {
        try await Auth.auth().currentUser?.updatePassword(to: password)
    }
    
    func deleteCurrentUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("Error deleting user: \(error)")
            }
        }
    }
    
    func sendVerificationEmail() async throws {
        try await self.userSession?.sendEmailVerification()
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let authSnapshot = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = authSnapshot.user
            let isEmailVerified = self.userSession?.isEmailVerified
            if let isVerified = isEmailVerified {
                if isVerified {
                    print("verified")
                    
                    self.userSettings = try? await APIService.fetchCurrentUserData(withEmail: self.userEmail)
                    
                    isFetchingData = false
                    
                    Constants.currentUserID = userSession?.uid ?? "undefined"
                    isDeviceUnlocked = true
                } else {
                    // Send a verification email
                    print("not verified")
                    
                    try await sendVerificationEmail()
                    
                    isFetchingData = false
                }
            }
        } catch {
            hasLoginError = true
            print("\(error.localizedDescription)")
        }
    }
    
    func isPasswordValidForSignUp(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    func passwordsMatch(currentPassword: String, reEnteredPassword: String) -> Bool {
        return currentPassword == reEnteredPassword
    }
        
    func signInWithBiometrics() {
        let context = LAContext()
        var biometricError: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &biometricError) {
            let localizedReason = "Authenticate using Biometrics"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Biometric authentication was successful
                        self.isBiometricUnlocked = true
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
            if let error = biometricError {
                // Handle the error
                print("Biometric authentication not available: \(error.localizedDescription)")
            } else {
                // Handle the case where biometric authentication is not supported
                print("Biometric authentication not supported on this device.")
            }
        }
    }
    
    func signInWithGoogle() async {
        guard let googleClientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found ")
        }
        
        let googleSignInConfig = GIDConfiguration(clientID: googleClientID)
        GIDSignIn.sharedInstance.configuration = googleSignInConfig
        
        guard let activeWindow = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = activeWindow.windows.first,
              let rootViewController = window.rootViewController
        else {
            print("No active root view controller found.")
            return
        }
        
        do {
            let googleUserAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let googleUser = googleUserAuth.user
            guard let googleIDToken = googleUser.idToken else { return }

            let googleAccessToken = googleUser.accessToken
            let googleCredential = GoogleAuthProvider.credential(withIDToken: googleIDToken.tokenString, accessToken: googleAccessToken.tokenString)
            
            
            let googleSignInResult = try await Auth.auth().signIn(with: googleCredential)
            
            let firebaseUser = googleSignInResult.user
            userEmail = firebaseUser.email ?? ""
            print("User \(firebaseUser.uid) signed in with \(firebaseUser.email ?? "unknown" )")
            
            let _ = try? await APIService.fetchCurrentUserData(withEmail: userEmail)
            isGoogleUnlocked = true
        }
        catch{
            print("Google Sign-In error: \(error.localizedDescription)")
        }
    }
}
