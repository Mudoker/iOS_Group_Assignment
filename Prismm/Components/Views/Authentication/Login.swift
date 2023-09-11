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
    @State private var isPasswordVisible: Bool = false
    @State var isValidUserName = false
    @State var isValidPassword = false
    @State private var showAlert = false
    @State var isForgotPassword = false
    @State var isSignUp = false
    // View Model
    @EnvironmentObject var authVM :AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    VStack (alignment: .center) {
                        // Push view
                        Spacer()
                        
                        //Logo
                        Image(authVM.isDarkMode ? Constants.darkThemeAppLogo : Constants.lightThemeAppLogo)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: authVM.logoImageSize, height: 0)
                            .padding(.vertical, authVM.imagePaddingVertical)
                        
                        // Title
                        Text ("Log in")
                            .font(.system(size: authVM.titleFont))
                            .bold()
                        
                        Text("Please sign in to continue")
                            .font(authVM.captionFont)
                            .bold()
                            .opacity(0.7)
                            .padding(.bottom)
                        
                        //Text field
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
                            text: $accountText,
                            textFieldTitle: "Password",
                            testFieldPlaceHolder: "Password",
                            titleFont: $authVM.textFieldTitleFont,
                            textFieldSizeHeight: $authVM.textFieldSizeHeight,
                            textFieldCorner: $authVM.textFieldCorner,
                            textFieldBorderWidth: $authVM.textFieldBorderWidth,
                            isPassword: .constant(true),
                            textFieldPlaceHolderFont: $authVM.textFieldPlaceHolderFont
                        )
                        .padding(.bottom)
                        
                        // Login button
                        Button(action: {
                            authVM.fetchUserData()
                            if authVM.validateUsername(accountText) && authVM.validatePassword(passwordText) {
                                print("ok")
                            } else {
                                showAlert.toggle()
                            }
                        }) {
                            Text("Login")
                                .foregroundColor(.white)
                                .bold()
                                .font(authVM.loginTextFont)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: authVM.loginButtonSizeHeight)
                                .background(
                                    RoundedRectangle(cornerRadius: authVM.textFieldCorner)
                                        .fill(authVM.isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                                )
                                .padding(.horizontal)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Login Failed"),
                                message: Text("Invalid username or password.\nPlease check again"),
                                dismissButton: .default(Text("Close"))
                            )
                        }
                        
                        // Helpers
                        HStack {
                            Button(action: {
                            }) {
                                Text("Forgot Password?")
                                    .bold()
                                    .font(authVM.conentFont)
                                    .padding()
                                    .padding(.horizontal)
                                    .opacity(0.8)
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Login Failed"),
                                    message: Text("Invalid username or password.\nPlease check again"),
                                    dismissButton: .default(Text("Close"))
                                )
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: SignUp()
                                .navigationBarTitle("")
                                .navigationBarHidden(false)) {
                                    Text("Sign Up")
                                        .bold()
                                        .font(authVM.conentFont)
                                        .padding()
                                        .padding(.horizontal)
                                        .opacity(0.8)
                                }
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            isSignUp = true
                                        }
                                )
                        }
                        
                        HStack {
                            Spacer()
                            
                            VStack {
                                Divider()
                                HStack {
                                    Button(action: {
                                        // Add action code here for the first button
                                    }) {
                                        RoundedRectangle(cornerRadius: proxy.size.width / 50)
                                            .frame(width: proxy.size.width / 4, height: proxy.size.height / 17)
                                            .background(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: proxy.size.width / 50)
                                                    .stroke(Color.black, lineWidth: 1)
                                                    .background(Color.white)
                                                    .overlay(
                                                        Image(systemName: "applelogo")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: proxy.size.width / 18)
                                                            .foregroundColor(.black)
                                                    )
                                            )
                                    }
                                    
                                    Button(action: {
                                        // Add action code here for the second button
                                    }) {
                                        RoundedRectangle(cornerRadius: proxy.size.width / 50)
                                            .frame(width: proxy.size.width / 4, height: proxy.size.height / 17)
                                            .background(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: proxy.size.width / 50)
                                                    .stroke(Color.black, lineWidth: 1)
                                                    .background(Color.white)
                                                    .overlay(
                                                        Image("mail")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: proxy.size.width / 18)
                                                            .foregroundColor(.black)
                                                    )
                                            )
                                    }
                                    
                                    Button(action: {
                                        // Add action code here for the third button
                                    }) {
                                        RoundedRectangle(cornerRadius: proxy.size.width / 50)
                                            .frame(width: proxy.size.width / 4, height: proxy.size.height / 17)
                                            .background(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: proxy.size.width / 50)
                                                    .stroke(Color.black, lineWidth: 1)
                                                    .background(Color.white)
                                                    .overlay(
                                                        Image("fb")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: proxy.size.width / 18)
                                                            .foregroundColor(.black)
                                                    )
                                            )
                                    }
                                    
                                    
                                }
                                .padding(.vertical)
                                
                                HStack {
                                    Spacer()
                                    
                                    VStack {
                                        Text("Sign in with")
                                            .bold()
                                            .opacity(0.8)
                                            .font(authVM.conentFont)
                                        
                                        Button(action: {
                                            authVM.bioMetricAuthenticate()
                                        }) {
                                            Image(systemName: "faceid")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: authVM.faceIdImageSize)
                                                .foregroundColor(authVM.isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.vertical)
                            }
                            Spacer()
                        }
                    }
                    .foregroundColor(authVM.isDarkMode ? .white : .black)
                    .padding(.horizontal)
                    .onAppear {
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            authVM.logoImageSize = proxy.size.width/2.2
                            authVM.textFieldSizeHeight = proxy.size.width/7
                            authVM.textFieldCorner = proxy.size.width/50
                            authVM.faceIdImageSize = proxy.size.width/10
                            authVM.loginButtonSizeHeight = authVM.textFieldSizeHeight
                        } else {
                            authVM.logoImageSize = proxy.size.width/2.8
                            authVM.textFieldSizeHeight = proxy.size.width/9
                            authVM.textFieldCorner = proxy.size.width/50
                            authVM.faceIdImageSize = proxy.size.width/12
                            authVM.imagePaddingVertical = 30
                            authVM.titleFont = 60
                            authVM.textFieldCorner = proxy.size.width/60
                            authVM.loginButtonSizeHeight = authVM.textFieldSizeHeight
                            authVM.conentFont = .title2
                            authVM.textFieldTitleFont = .title
                            authVM.loginTextFont = .largeTitle
                            authVM.captionFont = .title3
                            authVM.textFieldPlaceHolderFont = .title2
                        }
                    }
                    .onChange(of: accountText) { newValue in
                        isValidUserName = authVM.validateUsername(newValue)
                    }
                    .onChange(of: passwordText) { newValue in
                        isValidPassword = authVM.validatePassword(newValue)
                    }
                    
                    if authVM.isLoading {
                        Color.gray.opacity(0.3).ignoresSafeArea()
                        ProgressView("Fetching Data...")
                    }
                }
            }
            .background(authVM.isDarkMode ? .black : .white)
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
