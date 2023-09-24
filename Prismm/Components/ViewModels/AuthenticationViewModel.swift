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
    // Control state
    @Published var hasLoginError = false
    @Published var hasSignUpError = false
    @Published var isAlertPresent = false
    @Published var isDeviceUnlocked = false
    @Published var isGoogleUnlocked = false
    @Published var isBiometricUnlocked = false
    @Published var isPasswordResetRequested = false
    @Published var isSignUpMode = false
    @Published var isPasswordValid = false
    @Published var isReenteredPasswordValid = false
    @Published var isUserNameValid = false
    @Published var isFetchingData = false
    @Published var isShowloginPassword = ""
    @Published var loginPasswordText = ""
    @Published var loginAccountText = ""
    @Published var signUpAccountText = ""
    @Published var signUpPasswordText = ""
    @Published var signUpReEnterPasswordText = ""
    @Published var isShowSignUpPassword = ""
    @Published var isShowSignUpReEnterPassword = ""

    
    // Current user session
    @Published var userSession: FirebaseAuth.User?
    
    // Biometrics
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
    
    // Create user
    func createNewUser(withEmail email: String, password: String) async throws {
        do {
            // create using Firebase built-in
            let authSnapshot = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = authSnapshot.user
            
            // Create user data
            let newUser = User(id: authSnapshot.user.uid ,account: email)
            let encodedUser = try Firestore.Encoder().encode(newUser)
            
            // Create initial user settings data
            let userSettings = UserSetting(id: authSnapshot.user.uid, darkModeEnabled: false, language: "en", faceIdEnabled: false, pushNotificationsEnabled: false, messageNotificationsEnabled: false)
            let encodedSettings = try Firestore.Encoder().encode(userSettings)
            
            // Save user and settings data to Firestore
            try await Firestore.firestore().collection("users").document(newUser.id).setData(encodedUser)
            try await Firestore.firestore().collection("test_settings").document(newUser.id).setData(encodedSettings)
        } catch {
            hasSignUpError = true
            print("Error during sign-up: \(error.localizedDescription)")
        }
    }
    
    func resetView(){
        loginPasswordText = ""
        loginAccountText = ""
        signUpAccountText = ""
        signUpPasswordText = ""
        signUpReEnterPasswordText = ""
    }
    
    // Forgot password
    func resetUserPassword(withEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // Change password
    func updateUserPassword(to password: String) async throws {
        try await Auth.auth().currentUser?.updatePassword(to: password)
    }
    
    // Delete user
    func deleteCurrentUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("Error deleting user: \(error)")
            }
        }
    }
    
    // Verify account
    func sendVerificationEmail() async throws {
        try await self.userSession?.sendEmailVerification()
    }
    
    // User login
    func signIn(withEmail email: String, password: String) async throws -> Bool {
        do {
            // Authenticate with email and password
            let authSnapshot = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = authSnapshot.user
            let isEmailVerified = self.userSession?.isEmailVerified
            
            // Continue if email is verified
            if let isVerified = isEmailVerified {
                if isVerified {
                    // Fetch user data, store UID, and unlock device
                    Constants.currentUserID = userSession?.uid ?? "undefined"
                    

                    
                    
                    isFetchingData = false
                    isDeviceUnlocked = true
                    return true
                } else {
                    // Send a verification email if not verified
                    print("Email not verified")
                    try await sendVerificationEmail()
                    isFetchingData = false
                    return false
                }
            }
        } catch {
            // Handle login error
            hasLoginError = true
            isFetchingData = false
            print("\(error.localizedDescription)")
        }
        return false
    }

    
    // validate password
    func isPasswordValidForSignUp(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    // validate re-entered password
    func passwordsMatch(currentPassword: String, reEnteredPassword: String) -> Bool {
        return currentPassword == reEnteredPassword
    }
    
    // Biometrics login
    func signInWithBiometrics() {
        let context = LAContext()
        var biometricError: NSError?
        
        // Check if biometrics is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &biometricError) {
            // Authenticate using biometrics
            let localizedReason = "Authenticate with Biometrics"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Successful biometric authentication
                        self.isBiometricUnlocked = true
                    } else {
                        // Handle biometric authentication failure
                        if let error = authenticationError {
                            print("Biometric auth failed: \(error.localizedDescription)")
                        } else {
                            print("Biometric auth failed.")
                        }
                    }
                }
            }
        } else {
            // Biometrics not available or supported
            if let error = biometricError {
                print("Biometrics not available: \(error.localizedDescription)")
            } else {
                print("Biometrics not supported on this device.")
            }
        }
    }
    
    // Google sign-in
    func signInWithGoogle() async -> Bool {
        // Get Google client ID
        guard let googleClientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found ")
        }
        
        // Configure Google sign-in
        let googleSignInConfig = GIDConfiguration(clientID: googleClientID)
        GIDSignIn.sharedInstance.configuration = googleSignInConfig
        
        // Find the active UIWindow and root view controller
        guard let activeWindow = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = activeWindow.windows.first,
              let rootViewController = window.rootViewController
        else {
            print("No active root view controller found.")
            return false
        }
        
        do {
            // Perform Google sign-in
            let googleUserAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let googleUser = googleUserAuth.user
            guard let googleIDToken = googleUser.idToken else { return false }
            
            // Get Google access token
            let googleAccessToken = googleUser.accessToken
            
            // Create GoogleAuthProvider credential
            let googleCredential = GoogleAuthProvider.credential(withIDToken: googleIDToken.tokenString, accessToken: googleAccessToken.tokenString)
            
            // Sign in to Firebase with the Google credential
            let googleSignInResult = try await Auth.auth().signIn(with: googleCredential)
            
            // Print user information
            _ = googleSignInResult.user.email ?? ""
            print("User \(googleSignInResult.user.uid) signed in with \(googleSignInResult.user.email ?? "unknown" )")
            
            
            Constants.currentUserID = googleSignInResult.user.uid
            // Successful sign-in -> Unlock device
            isGoogleUnlocked = true
            return true
        } catch {
            // Handle errors
            print("Google Sign-In error: \(error.localizedDescription)")
            return false
        }
    }
}
