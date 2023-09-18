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
  Last modified: 11/09/2023
  Acknowledgement: None
*/

import SwiftUI
import LocalAuthentication
import GoogleSignIn
import GoogleSignInSwift

struct Login: View {
    // Control state
    @State var accountText = ""
    @State var passwordText = ""
    @State private var isPasswordVisible: Bool = false

    // View Model
    @StateObject var authVM :AuthenticationViewModel
    @ObservedObject var settingVM = SettingViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    VStack (alignment: .center) {
                        // Push view
                        Spacer()
                        
                        //Logo
                        Image(settingVM.isDarkMode ? Constants.darkThemeAppLogo : Constants.lightThemeAppLogo)
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
                            titleFont: authVM.textFieldTitleFont,
                            textFieldSizeHeight: authVM.textFieldSizeHeight,
                            textFieldCorner: authVM.textFieldCorner,
                            textFieldBorderWidth: authVM.textFieldBorderWidth,
                            isPassword: false,
                            textFieldPlaceHolderFont: authVM.textFieldPlaceHolderFont, isDarkMode: settingVM.isDarkMode
                        )
                        .padding(.bottom)
                        
                        CustomTextField(
                            text: $passwordText,
                            textFieldTitle: "Password",
                            testFieldPlaceHolder: "Password",
                            titleFont: authVM.textFieldTitleFont,
                            textFieldSizeHeight: authVM.textFieldSizeHeight,
                            textFieldCorner: authVM.textFieldCorner,
                            textFieldBorderWidth: authVM.textFieldBorderWidth,
                            isPassword: true,
                            textFieldPlaceHolderFont: authVM.textFieldPlaceHolderFont,
                            isDarkMode: settingVM.isDarkMode
                        )
                        .padding(.bottom)
                        
                        // Login button
                        Button(action: {
                            
                            Task {
                                authVM.isLoading = true
                                try await authVM.signIn(withEmail: accountText, password: passwordText)
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
                                        .fill(settingVM.isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                                )
                                .padding(.horizontal)
                        }
                        .alert(isPresented: $authVM.logInError) {
                            Alert(
                                title: Text("Login Failed"),
                                message: Text("Invalid username or password.\nPlease check again"),
                                dismissButton: .default(Text("Close"))
                            )
                        }
                        .navigationDestination(isPresented: $authVM.isUnlocked) {
                            HomeView()
                                .navigationBarBackButtonHidden(true)
                        }
                        
                        // Helpers
                        HStack {
                            Button(action: {
                                authVM.isForgotPassword.toggle()
                            }) {
                                Text("Forgot Password?")
                                    .bold()
                                    .font(authVM.conentFont)
                                    .padding()
                                    .padding(.horizontal)
                                    .opacity(0.8)
                            }
                            .alert(isPresented:$authVM.logInError) {
                                Alert(
                                    title: Text("Login Failed"),
                                    message: Text("Invalid username or password.\nPlease check again"),
                                    dismissButton: .default(Text("Close"))
                                )
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: SignUp(authVM: authVM)
                                .navigationBarTitle("")
                                .navigationBarHidden(false)) {
                                    Text("Sign Up")
                                        .bold()
                                        .font(authVM.conentFont)
                                        .padding()
                                        .padding(.horizontal)
                                        .opacity(0.8)
                                }
                        }
                        
                        HStack {
                            Spacer()
                            
                            VStack {
                                Divider()
                                HStack {
                                    
                                    Button(action: {
                                        authVM.isLoading = true
                                        Task{
                                            await authVM.signInGoogle()
                                            authVM.isLoading = false
                                        }
                                    }) {
                                        RoundedRectangle(cornerRadius: proxy.size.width / 50)
                                            .frame(width: proxy.size.width / 2, height: proxy.size.height / 17)
                                            .background(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: proxy.size.width / 50)
                                                    .stroke(Color.black, lineWidth: 1)
                                                    .background(Color.white)
                                                    .overlay(
                                                        HStack {
                                                            Image("mail")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: proxy.size.width / 18)
                                                                .foregroundColor(.black)
                                                            
                                                            Text("Login with Google")
                                                        }
                                                    )
                                            )
                                    }
                                    .navigationDestination(isPresented: $authVM.isUnlockedGoogle) {
                                        TabBar()
                                            .navigationBarBackButtonHidden(true)
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
                                                .foregroundColor(settingVM.isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.vertical)
                            }
                            Spacer()
                        }
                    }
                    .foregroundColor(settingVM.isDarkMode ? .white : .black)
                    .padding(.horizontal)
                    .onAppear {
                        authVM.proxySize = proxy.size
                    }
                    
                    if authVM.isLoading {
                        Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
                        ProgressView("Loading...")
                    }
                }
                .background(settingVM.isDarkMode ? .black : .white)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(authVM: AuthenticationViewModel())
    }
}
