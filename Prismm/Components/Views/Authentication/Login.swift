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
    // View Model
    @StateObject var authVM = AuthenticationViewModel()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var manager : AppManager
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    VStack (alignment: .center) {
                        // Push view
                        Spacer()
                        //MARK: dataControllerVM.userSettings!.darkModeEnabled ? Constants.darkThemeAppLogo :
                        //Logo
                        Image( (colorScheme == .dark) ? Constants.darkThemeAppLogo : Constants.lightThemeAppLogo)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: authVM.logoImageSize, height: 0)
                            .padding(.vertical, authVM.imageVerticalPadding)
                        
                        // Title
                        Text ("Log in")
                            .font(.system(size: authVM.titleFontSize))
                            .bold()
                        
                        Text("Please sign in to continue")
                            .font(authVM.captionFont)
                            .bold()
                            .opacity(0.7)
                            .padding(.bottom)
                        
                        //Text field
                        CustomTextField(
                            text: $authVM.loginAccountText,
                            textFieldTitle: "Username",
                            testFieldPlaceHolder: "Username or Account",
                            titleFont: authVM.textFieldTitleFont,
                            textFieldSizeHeight: authVM.textFieldSizeHeight,
                            textFieldCorner: authVM.textFieldCornerRadius,
                            textFieldBorderWidth: authVM.textFieldBorderWidth,
                            isPassword: false,
                            textFieldPlaceHolderFont: authVM.textFieldPlaceHolderFont, isDarkModeEnabled: (colorScheme == .dark)
                        )
                        .padding(.bottom)
                        
                        CustomTextField(
                            text: $authVM.loginPasswordText,
                            textFieldTitle: "Password",
                            testFieldPlaceHolder: "Password",
                            titleFont: authVM.textFieldTitleFont,
                            textFieldSizeHeight: authVM.textFieldSizeHeight,
                            textFieldCorner: authVM.textFieldCornerRadius,
                            textFieldBorderWidth: authVM.textFieldBorderWidth,
                            isPassword: true,
                            textFieldPlaceHolderFont: authVM.textFieldPlaceHolderFont,
                            isDarkModeEnabled: (colorScheme == .dark)
                        )
                        .padding(.bottom)
                        
                        // Login button
                        Button(action: {
                            Task {
                                authVM.isFetchingData = true
                                manager.isSignIn = try await authVM.signIn(withEmail: authVM.loginAccountText, password: authVM.loginPasswordText)
                            }
                        }) {
                            Text("Login")
                                .foregroundColor(.white)
                                .bold()
                                .font(authVM.loginTextFont)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: authVM.loginButtonHeight)
                                .background(
                                    RoundedRectangle(cornerRadius: authVM.textFieldCornerRadius)
                                        .fill((colorScheme == .dark) ? Constants.darkThemeColor : Constants.lightThemeColor)
                                )
                                .padding(.horizontal)
                        }
                        .alert(isPresented: $authVM.hasLoginError) {
                            Alert(
                                title: Text("Login Failed"),
                                message: Text("Invalid username or password.\nPlease check again"),
                                dismissButton: .default(Text("Close"))
                            )
                        }
                        
                        
                        // Helpers
                        HStack {
                            Button(action: {
                                //                                authVM.isForgotPassword.toggle()
                                Task {
                                    try await authVM.resetUserPassword(withEmail: "huuquoc7603@gmail.com")
                                }
                            }) {
                                Text("Forgot Password?")
                                    .bold()
                                    .font(authVM.conentFont)
                                    .padding()
                                    .padding(.horizontal)
                                    .opacity(0.8)
                            }
                            .alert(isPresented:$authVM.hasLoginError) {
                                Alert(
                                    title: Text("Login Failed"),
                                    message: Text("Invalid username or password.\nPlease check again"),
                                    dismissButton: .default(Text("Close"))
                                )
                            }
                            
                            // Push view
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
                        
                        // Aligning items
                        HStack {
                            // Push view
                            Spacer()
                            
                            VStack {
                                Divider()
                                
                                HStack {
                                    // Google sign in
                                    Button(action: {
                                        authVM.isFetchingData = true
                                        Task{
                                            manager.isSignIn = await authVM.signInWithGoogle()
                                            authVM.isFetchingData = false
                                        }
                                    }) {
                                        RoundedRectangle(cornerRadius: proxy.size.width / 50)
                                            .frame(width: proxy.size.width / 2, height: proxy.size.height / 17)
                                            .background((colorScheme == .dark) ? Color.clear : Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: proxy.size.width / 50)
                                                    .stroke(Color.black, lineWidth: 1)
                                                    .background((colorScheme == .dark) ? Color.clear : Color.white)
                                                    .overlay(
                                                        HStack {
                                                            Image("mail")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: proxy.size.width / 18)
                                                                .foregroundColor(.black)
                                                            
                                                            Text("Login with Google")
                                                                .foregroundColor(.black)
                                                        }
                                                    )
                                            )
                                    }
                                }
                                .padding(.vertical)
                                
                                // Biometrics login
                                HStack {
                                    // Push view
                                    Spacer()
                                    
                                    VStack {
                                        Text("Sign in with")
                                            .bold()
                                            .opacity(0.8)
                                            .font(authVM.conentFont)
                                        
                                        Button(action: {
                                            Task{
                                                let result = await authVM.signInWithBiometrics()
                                                
                                                manager.isSignIn = result
                                                print("Bio Test")
                                                print(manager.isSignIn)
                                            }
                                            
                                        }) {
                                            Image(systemName: "faceid")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: authVM.faceIdImageSize)
                                                .foregroundColor((colorScheme == .dark) ? Constants.darkThemeColor : Constants.lightThemeColor)
                                        }
                                    }
                                    
                                    // Push view
                                    Spacer()
                                }
                                .padding(.vertical)
                            }
                            
                            // Push view
                            Spacer()
                        }
                    }
                    .foregroundColor((colorScheme == .dark) ? .white : .black)
                    .padding(.horizontal)
                    .onAppear {
                        authVM.proxySize = proxy.size
                        
                    }
                    .onChange(of: manager.isSignIn) { newValue in
                        authVM.resetView()
                    }
                    
                    // Progress view when fetching user
                    if authVM.isFetchingData {
                        Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
                        ProgressView("Loading...")
                    }
                }
                .background((colorScheme == .dark) ? .black : .white)
            }
        }
    }
}

//struct Login_Previews: PreviewProvider {
//    static var previews: some View {
//        Login(authVM: AuthenticationViewModel())
//    }
//}
