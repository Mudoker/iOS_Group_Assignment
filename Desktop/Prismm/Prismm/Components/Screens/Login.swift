//
//  Login.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI
import LocalAuthentication

struct Login: View {
    // Responsive
    @State var titleFont: CGFloat = 40
    @State var logoImageSize: CGFloat = 0
    @State var captionFont: Font = .caption
    @State var textFieldTitleFont: Font = .body
    @State var textFieldSizeHeight: CGFloat = 0
    @State var textFieldCorner: CGFloat = 0
    @State var textFieldBorderWidth: CGFloat = 2.5
    @State var faceIdImageSize: CGFloat = 0
    
    
    // Control state
    @State var accountText = ""
    @State var passwordText = ""
    @State var isDarkMode = false
    @State private var isPasswordVisible: Bool = false
    @State var isUnlocked = false

    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .center) {
                // Push view
                Spacer()
                
                //Logo
                Image(isDarkMode ? "logodark" : "logolight")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: logoImageSize, height: 0)
                    .padding(.vertical)
                
                // Title
                Text ("Log in")
                    .font(.system(size: titleFont))
                    .bold()
                
                Text("Please sign in to continue")
                    .font(captionFont)
                    .bold()
                    .opacity(0.7)
                    .padding(.bottom)
                
                //Text field
                CustomTextField(text: $accountText, textFieldTitle: "Username", isDarkMode: $isDarkMode, testFieldPlaceHolder: "Username or Account", titleFont: $textFieldTitleFont, textFieldSizeHeight: $textFieldSizeHeight, textFieldCorner: $textFieldCorner, textFieldBorderWidth: $textFieldBorderWidth, isPassword: .constant(false))
                    .padding(.bottom)
                
                CustomTextField(text: $passwordText, textFieldTitle: "Password", isDarkMode: $isDarkMode, testFieldPlaceHolder: "Password", titleFont: $textFieldTitleFont, textFieldSizeHeight: $textFieldSizeHeight, textFieldCorner: $textFieldCorner, textFieldBorderWidth: $textFieldBorderWidth, isPassword: .constant(true))
                    .padding(.bottom)
                
                // Login button
                Button(action: {
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                        )
                        .padding(.horizontal)
                }
                
                HStack {
                    Button(action: {
                        // Add your login action here
                    }) {
                        Text("Forgot Password?")
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .opacity(0.8)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Add your login action here
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .opacity(0.8)
                    }
                }
                
                HStack {
                    Spacer()
                    VStack {
                        Text("Sign in with")
                            .bold()
                            .opacity(0.8)
                        
                        Button(action: {
                            bioMetricAuthenticate()
                        }) {
                            Image(systemName: "faceid")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: faceIdImageSize)
                                .foregroundColor(isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                        }
                        
                    }
                    Spacer()
                }
                .padding(.top)
                
                // Push view
                Spacer()
            }
            .foregroundColor(isDarkMode ? .white : .black)
            .padding(.horizontal)
            .onAppear {
                logoImageSize = proxy.size.width/2.2
                textFieldSizeHeight = proxy.size.width/7
                textFieldCorner = proxy.size.width/50
                faceIdImageSize = proxy.size.width/10
            }
        }
        .background(isDarkMode ? .black : .white)
    }
    
    func bioMetricAuthenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Account Autofill") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Biometric authentication was successful
                        isUnlocked = true
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

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

