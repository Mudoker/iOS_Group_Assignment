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

    // View Model
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .center) {
                // Push view
                Spacer()
                
                //Logo
                Image(isDarkMode ? Constants.darkThemeAppLogo : Constants.lightThemeAppLogo)
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
                            authenticationViewModel.bioMetricAuthenticate()
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
                if UIDevice.current.userInterfaceIdiom == .phone {
                    logoImageSize = proxy.size.width/2.2
                    textFieldSizeHeight = proxy.size.width/7
                    textFieldCorner = proxy.size.width/50
                    faceIdImageSize = proxy.size.width/10
                }
                
            }
        }
        .background(authenticationViewModel.isDarkMode ? .black : .white)
    }
    
    
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

