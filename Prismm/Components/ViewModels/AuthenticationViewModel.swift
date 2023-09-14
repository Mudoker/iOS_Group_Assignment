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
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

protocol SignUpFormProtocol{
    var formIsValid: Bool{get}
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    
    @Published var logInError = false
    @Published var signUpError = false
    @Published var isAlert = false
    
    @Published var isUnlocked = false
    @Published var isUnlockedGoogle = false

    @Published var isDarkMode = false
    @Published var currentEmail = ""
    @ObservedObject var uploadVM = UploadPostViewModel()
    @Published var userToken: String {
        didSet {
            UserDefaults.standard.set(userToken, forKey: "userToken")
        }
    }
    
    @Published var userSession : FirebaseAuth.User?
    @Published var currentUser : User?
    @Published var currentSetting: Setting?
    
    
    // set user token for bio metric login
    init() {
        self.userToken = UserDefaults.standard.string(forKey: "userToken") ?? ""
        self.userSession = Auth.auth().currentUser
        
        //init setting data
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
    
    func signUp (withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, password: password, username: email)
            let setting = Setting(id: result.user.uid, isDarkMode: false, isEnglish: true, isFaceId: false, isPushNotification: false, isMessageNotification: false) //new create setting data
            let encodedUser = try Firestore.Encoder().encode(user)
            let encodedSetting = try Firestore.Encoder().encode(setting)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            try await Firestore.firestore().collection("settings").document(user.id).setData(encodedSetting) //create new setting document on firebase
            signUpError = false
        } catch {
            signUpError = true
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUserData()
            isLoading = false
            isUnlocked = true // Set isUnlocked to true after successfully fetching posts
        } catch {
            logInError = true
            print("\(error.localizedDescription)")
        }
    }
    
    // Validate password (at least 8 characters + not contating special symbols)
    func validatePasswordSignUp(_ password: String) -> Bool {
        if password.count >= 8 && !password.containsSpecialSymbols() {
            return true
        } else {
            return false
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
        
        if !snapshot.exists {
            do{
                let user = User(id: uid, password: "password", username: currentEmail)
                let encodedUser = try Firestore.Encoder().encode(user)
                try await Firestore.firestore().collection("users").document(uid).setData(encodedUser)

            }catch{
               print("ERROR: Fail to add user data")
            }
        }else{
            self.currentUser = try? snapshot.data(as: User.self)
        }
        
        
        //new: fetch setting data
        guard let snapshot1 = try? await Firestore.firestore().collection("settings").document(uid).getDocument() else {return}
        
        if !snapshot1.exists {
            do{
                let setting = Setting(id: uid, isDarkMode: false, isEnglish: true, isFaceId: false, isPushNotification: false, isMessageNotification: false) //new: create new setting data
                let encodedSetting = try Firestore.Encoder().encode(setting)
            
                try await Firestore.firestore().collection("settings").document(uid).setData(encodedSetting)
            }catch{
               print("ERROR: Fail to add setting data")
            }
        }else{
            self.currentSetting = try! snapshot1.data(as: Setting.self)
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
    
    
    func signInGoogle() async{
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found ")
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("no root view controller")
            return
        }
        
        do{
            let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuth.user
            guard let idToken = user.idToken else{return}
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            
            let result = try await Auth.auth().signIn(with: credential)
            
            let firebaseUser = result.user
            currentEmail=firebaseUser.email ?? ""
            print("User \(firebaseUser.uid) signed in with \(firebaseUser.email ?? "unknown" )")
            await fetchUserData()
            
            isUnlockedGoogle = true
        }
        catch{
            print(error.localizedDescription)
            return
        }
    }
}
