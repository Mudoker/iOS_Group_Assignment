//
//  Login.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI

struct SignUp: View {
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
    @State var confrimPasswordText = ""
    @State var isDarkMode = true
    @State private var isPasswordVisible: Bool = false
    @State var isValidPassword = false
    @State var isValidReEnterPassword = false

    // View Model
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .center) {
                // Push view
                Spacer()
                
                // Logo
                Image(isDarkMode ? Constants.darkThemeAppLogo : Constants.lightThemeAppLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: logoImageSize, height: 0)
                    .padding(.vertical)
                
                // Title
                Text ("Sign Up")
                    .font(.system(size: titleFont))
                    .bold()
                
                Text("Create a new profile")
                    .font(captionFont)
                    .bold()
                    .opacity(0.7)
                         
                // Text field
                VStack {
                    CustomTextField(text: $accountText, textFieldTitle: "Username", isDarkMode: $isDarkMode, testFieldPlaceHolder: "Username or Account", titleFont: $textFieldTitleFont, textFieldSizeHeight: $textFieldSizeHeight, textFieldCorner: $textFieldCorner, textFieldBorderWidth: $textFieldBorderWidth, isPassword: .constant(false))
                        .padding(.bottom)
                    
                    CustomTextField(text: $passwordText, textFieldTitle: "Password", isDarkMode: $isDarkMode, testFieldPlaceHolder: "Password", titleFont: $textFieldTitleFont, textFieldSizeHeight: $textFieldSizeHeight, textFieldCorner: $textFieldCorner, textFieldBorderWidth: $textFieldBorderWidth, isPassword: .constant(true))
                        
                    HStack {
                        if passwordText.isEmpty {
                            Text("At least 8 characters and not contain special symbols")
                                .font(.caption)
                                .padding(.bottom, 5)
                                .opacity(0.7)
                        } else {
                            if isValidPassword {
                                Text("Invalid Password")
                                    .font(.caption)
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                                    .foregroundColor(.red)
                            } else {
                                Text("Password valid")
                                    .font(.caption)
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    CustomTextField(text: $confrimPasswordText, textFieldTitle: "Confirm Password", isDarkMode: $isDarkMode, testFieldPlaceHolder: "Password", titleFont: $textFieldTitleFont, textFieldSizeHeight: $textFieldSizeHeight, textFieldCorner: $textFieldCorner, textFieldBorderWidth: $textFieldBorderWidth, isPassword: .constant(true))
                    
                    HStack {
                        if confrimPasswordText.isEmpty {
                            Text("Re-enter your password")
                                .font(.caption)
                                .padding(.bottom, 5)
                                .opacity(0.7)
                        } else {
                            if isValidReEnterPassword {
                                Text("Matched Password!")
                                    .font(.caption)
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                                    .foregroundColor(.green)
                            } else {
                                Text("Password not match!")
                                    .font(.caption)
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
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                            )
                            .padding(.horizontal)
                    }
                }
                
                
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
            .onChange(of: passwordText) {newValue in
                isValidPassword = authenticationViewModel.validatePassword(newValue)
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

