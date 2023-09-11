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
    @State private var isPasswordVisible: Bool = false
    @State var isValidPassword = false
    @State var isValidReEnterPassword = false
    @State var isValidUserName = false
    
    // View Model
    @EnvironmentObject var authVM:AuthenticationViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .center) {
                                // Push view
                                Spacer()
                // Logo
                Image(authVM.isDarkMode ? Constants.darkThemeAppLogo : Constants.lightThemeAppLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: authVM.logoImageSize, height: 0)
                    .padding(.vertical, authVM.imagePaddingVertical)

                // Title
                Text ("Sign Up")
                    .font(.system(size: authVM.titleFont))
                    .bold()
                
                Text("Create a new profile")
                    .font(authVM.captionFont)
                    .bold()
                    .opacity(0.7)
                         
                // Text field
                VStack {
                    CustomTextField(
                        text: $accountText,
                        textFieldTitle: "Username",
                        testFieldPlaceHolder: "Username or Account",
                        titleFont: $authVM.textFieldTitleFont,
                        textFieldSizeHeight: $authVM.textFieldSizeHeight,
                        textFieldCorner: $authVM.textFieldCorner,
                        textFieldBorderWidth: $authVM.textFieldBorderWidth,
                        isPassword: .constant(false),
                        textFieldPlaceHolderFont: $authVM.textFieldPlaceHolderFont
                    )
                    .padding(.bottom)

                    
                    CustomTextField(
                        text: $passwordText,
                        textFieldTitle: "Password",
                        testFieldPlaceHolder: "Password",
                        titleFont: $authVM.textFieldTitleFont,
                        textFieldSizeHeight: $authVM.textFieldSizeHeight,
                        textFieldCorner: $authVM.textFieldCorner,
                        textFieldBorderWidth: $authVM.textFieldBorderWidth,
                        isPassword: .constant(true),
                        textFieldPlaceHolderFont: $authVM.textFieldPlaceHolderFont
                    )
                        
                    HStack {
                        if passwordText.isEmpty {
                            Text("At least 8 characters and not contain special symbols")
                                .font(authVM.captionFont )
                                .padding(.bottom, 5)
                                .opacity(0.7)
                        } else {
                            if isValidPassword {
                                Text("Invalid Password")
                                    .font(authVM.captionFont )
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                                    .foregroundColor(.red)
                            } else {
                                Text("Password valid")
                                    .font(authVM.captionFont )
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
                        titleFont: $authVM.textFieldTitleFont,
                        textFieldSizeHeight: $authVM.textFieldSizeHeight,
                        textFieldCorner: $authVM.textFieldCorner,
                        textFieldBorderWidth: $authVM.textFieldBorderWidth,
                        isPassword: .constant(true),
                        textFieldPlaceHolderFont: $authVM.textFieldPlaceHolderFont
                    )
                    
                    HStack {
                        if confrimPasswordText.isEmpty {
                            Text("Re-enter your password")
                                .font(authVM.captionFont )
                                .padding(.bottom, 5)
                                .opacity(0.7)
                        } else {
                            if isValidReEnterPassword {
                                Text("Matched Password!")
                                    .font(authVM.captionFont )
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                                    .foregroundColor(.green)
                            } else {
                                Text("Password not match!")
                                    .font(authVM.captionFont )
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
                        Task {
                            try await authVM.signUp(withEmail: "ntbngoc0123@gmail.com", password: "10102003", fullName: "Ngoc Nguyen")
                        }
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .font(authVM.loginTextFont)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: authVM.loginButtonSizeHeight)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(authVM.isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                            )
                            .padding(.horizontal)
                    }
                }
                
                
                // Push view
                Spacer()
            }
            .foregroundColor(authVM.isDarkMode ? .white : .black)
            .padding(.horizontal)
            .onChange(of: accountText) {newValue in
                isValidUserName = authVM.validateUsernameSignUp(newValue)
            }
            .onChange(of: passwordText) {newValue in
                isValidPassword = authVM.validatePasswordSignUp(newValue)
            }
            .onChange(of: confrimPasswordText) {newValue in
                isValidReEnterPassword = authVM.isMatchPassword(currentPassword: passwordText, reEnteredPassword: newValue)
            }
        }
        .background(authVM.isDarkMode ? .black : .white)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
