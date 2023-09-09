//
//  Login.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI

struct SignUp: View {
    // Control state
    @State var accountText = ""
    @State var passwordText = ""
    @State var confrimPasswordText = ""
    @State var isDarkMode = true
    @State private var isPasswordVisible: Bool = false
    @State var isValidPassword = false
    @State var isValidReEnterPassword = false
    @State var isValidUserName = false
    
    // View Model
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .center) {
                // Push view
                Spacer()
                
                // Logo
                Image(authenticationViewModel.isDarkMode ? Constants.darkThemeAppLogo : Constants.lightThemeAppLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: authenticationViewModel.logoImageSize, height: 0)
                    .padding(.vertical, authenticationViewModel.imagePaddingVertical)

                // Title
                Text ("Sign Up")
                    .font(.system(size: authenticationViewModel.titleFont))
                    .bold()
                
                Text("Create a new profile")
                    .font(authenticationViewModel.captionFont)
                    .bold()
                    .opacity(0.7)
                         
                // Text field
                VStack {
                    CustomTextField(
                        text: $accountText,
                        textFieldTitle: "Username",
                        testFieldPlaceHolder: "Username or Account",
                        titleFont: $authenticationViewModel.textFieldTitleFont,
                        textFieldSizeHeight: $authenticationViewModel.textFieldSizeHeight,
                        textFieldCorner: $authenticationViewModel.textFieldCorner,
                        textFieldBorderWidth: $authenticationViewModel.textFieldBorderWidth,
                        isPassword: .constant(false),
                        textFieldPlaceHolderFont: $authenticationViewModel.textFieldPlaceHolderFont
                    )
                    .padding(.bottom)

                    
                    CustomTextField(
                        text: $accountText,
                        textFieldTitle: "Password",
                        testFieldPlaceHolder: "Password",
                        titleFont: $authenticationViewModel.textFieldTitleFont,
                        textFieldSizeHeight: $authenticationViewModel.textFieldSizeHeight,
                        textFieldCorner: $authenticationViewModel.textFieldCorner,
                        textFieldBorderWidth: $authenticationViewModel.textFieldBorderWidth,
                        isPassword: .constant(true),
                        textFieldPlaceHolderFont: $authenticationViewModel.textFieldPlaceHolderFont
                    )
                        
                    HStack {
                        if passwordText.isEmpty {
                            Text("At least 8 characters and not contain special symbols")
                                .font(authenticationViewModel.captionFont )
                                .padding(.bottom, 5)
                                .opacity(0.7)
                        } else {
                            if isValidPassword {
                                Text("Invalid Password")
                                    .font(authenticationViewModel.captionFont )
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                                    .foregroundColor(.red)
                            } else {
                                Text("Password valid")
                                    .font(authenticationViewModel.captionFont )
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    CustomTextField(
                        text: $confrimPasswordText,
                        textFieldTitle: "Confirm Password",
                        testFieldPlaceHolder: "Password",
                        titleFont: $authenticationViewModel.textFieldTitleFont,
                        textFieldSizeHeight: $authenticationViewModel.textFieldSizeHeight,
                        textFieldCorner: $authenticationViewModel.textFieldCorner,
                        textFieldBorderWidth: $authenticationViewModel.textFieldBorderWidth,
                        isPassword: .constant(true),
                        textFieldPlaceHolderFont: $authenticationViewModel.textFieldPlaceHolderFont
                    )
                    
                    HStack {
                        if confrimPasswordText.isEmpty {
                            Text("Re-enter your password")
                                .font(authenticationViewModel.captionFont )
                                .padding(.bottom, 5)
                                .opacity(0.7)
                        } else {
                            if isValidReEnterPassword {
                                Text("Matched Password!")
                                    .font(authenticationViewModel.captionFont )
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                                    .foregroundColor(.green)
                            } else {
                                Text("Password not match!")
                                    .font(authenticationViewModel.captionFont )
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                // Signup button
                VStack {
                    Button(action: {
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .font(authenticationViewModel.loginTextFont)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: authenticationViewModel.loginButtonSizeHeight)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(authenticationViewModel.isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                            )
                            .padding(.horizontal)
                    }
                }
                
                
                // Push view
                Spacer()
            }
            .foregroundColor(authenticationViewModel.isDarkMode ? .white : .black)
            .padding(.horizontal)
            .onAppear {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    authenticationViewModel.logoImageSize = proxy.size.width/2.2
                    authenticationViewModel.textFieldSizeHeight = proxy.size.width/7
                    authenticationViewModel.textFieldCorner = proxy.size.width/50
                    authenticationViewModel.faceIdImageSize = proxy.size.width/10
                    authenticationViewModel.loginButtonSizeHeight = authenticationViewModel.textFieldSizeHeight
                } else {
                    authenticationViewModel.logoImageSize = proxy.size.width/2.8
                    authenticationViewModel.textFieldSizeHeight = proxy.size.width/9
                    authenticationViewModel.textFieldCorner = proxy.size.width/50
                    authenticationViewModel.faceIdImageSize = proxy.size.width/12
                    authenticationViewModel.imagePaddingVertical = 30
                    authenticationViewModel.titleFont = 60
                    authenticationViewModel.textFieldCorner = proxy.size.width/60
                    authenticationViewModel.loginButtonSizeHeight = authenticationViewModel.textFieldSizeHeight
                    authenticationViewModel.conentFont = .title2
                    authenticationViewModel.textFieldTitleFont = .title
                    authenticationViewModel.loginTextFont = .largeTitle
                    authenticationViewModel.captionFont = .title3
                    authenticationViewModel.textFieldPlaceHolderFont = .title2
                }
            }
            .onChange(of: accountText) {newValue in
                isValidUserName = authenticationViewModel.validateUsernameSignUp(newValue)
            }
            .onChange(of: passwordText) {newValue in
                isValidPassword = authenticationViewModel.validatePasswordSignUp(newValue)
            }
            .onChange(of: confrimPasswordText) {newValue in
                isValidReEnterPassword = authenticationViewModel.isMatchPassword(currentPassword: passwordText, reEnteredPassword: newValue)
            }
        }
        .background(authenticationViewModel.isDarkMode ? .black : .white)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}

