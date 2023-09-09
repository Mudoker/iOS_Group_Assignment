//
//  Login.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI
import LocalAuthentication

struct Login: View {
    // Control state
    @State var accountText = ""
    @State var passwordText = ""
    @State var isDarkMode = false
    @State private var isPasswordVisible: Bool = false
    @State var isUnlocked = false
    @State var isValidUserName = false
    @State var isValidPassword = false
    @State private var showAlert = false
    
    
    // View Model
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack (alignment: .center) {
                    // Push view
                    Spacer()
                    
                    //Logo
                    Image(authenticationViewModel.isDarkMode ? Constants.darkThemeAppLogo : Constants.lightThemeAppLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: authenticationViewModel.logoImageSize, height: 0)
                        .padding(.vertical, authenticationViewModel.imagePaddingVertical)
                    
                    // Title
                    Text ("Log in")
                        .font(.system(size: authenticationViewModel.titleFont))
                        .bold()
                    
                    Text("Please sign in to continue")
                        .font(authenticationViewModel.captionFont)
                        .bold()
                        .opacity(0.7)
                        .padding(.bottom)
                    
                    //Text field
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
                    .padding(.bottom)
                    
                    // Login button
                    Button(action: {
                        authenticationViewModel.fetchUserData()
                        showAlert.toggle()
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .bold()
                            .font(authenticationViewModel.loginTextFont)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: authenticationViewModel.loginButtonSizeHeight)
                            .background(
                                RoundedRectangle(cornerRadius: authenticationViewModel.textFieldCorner)
                                    .fill(authenticationViewModel.isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                            )
                            .padding(.horizontal)
                    }
                    //                    .alert(isPresented: $showAlert) {
                    //                        Alert(
                    //                            title: Text("Login Failed"),
                    //                            message: Text("Invalid username or password.\nPlease check again"),
                    //                            dismissButton: .default(Text("Close"))
                    //                        )
                    //                    }
                    
                    HStack {
                        Button(action: {
                            // Add your login action here
                        }) {
                            Text("Forgot Password?")
                                .bold()
                                .font(authenticationViewModel.conentFont)
                                .padding()
                                .padding(.horizontal)
                                .opacity(0.8)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Add your login action here
                        }) {
                            Text("Sign Up")
                                .bold()
                                .font(authenticationViewModel.conentFont)
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
                                .font(authenticationViewModel.conentFont)
                            
                            Button(action: {
                                authenticationViewModel.bioMetricAuthenticate()
                            }) {
                                Image(systemName: "faceid")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: authenticationViewModel.faceIdImageSize)
                                    .foregroundColor(authenticationViewModel.isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                            }
                            
                        }
                        Spacer()
                    }
                    .padding(.top)
                    
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
                        //                    authenticationViewModel.loginTextFont = .body
                        
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
                .onChange(of: accountText) { newValue in
                    isValidUserName = authenticationViewModel.validateUsername(newValue)
                }
                .onChange(of: passwordText) { newValue in
                    isValidPassword = authenticationViewModel.validatePassword(newValue)
                }
                if authenticationViewModel.isLoading {
                    Color.gray.opacity(0.3).ignoresSafeArea()
                    ProgressView("Fetching Data...")
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

