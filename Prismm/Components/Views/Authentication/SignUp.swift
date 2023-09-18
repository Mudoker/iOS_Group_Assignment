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



struct SignUp: View {
    // Control state
    @State var accountText = ""
    @State var passwordText = ""
    @State var confrimPasswordText = ""
    @State private var isPasswordVisible: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // View Model
    @ObservedObject var authVM = AuthenticationViewModel()
    @ObservedObject var settingVM = SettingViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack (alignment: .center) {
                    // Push view
                    Spacer()
                    
                    // Logo
                    Image(settingVM.isDarkMode ? Constants.darkThemeAppLogo : Constants.lightThemeAppLogo)
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
                            titleFont: authVM.textFieldTitleFont,
                            textFieldSizeHeight: authVM.textFieldSizeHeight,
                            textFieldCorner: authVM.textFieldCorner,
                            textFieldBorderWidth: authVM.textFieldBorderWidth,
                            isPassword: false,
                            textFieldPlaceHolderFont: authVM.textFieldPlaceHolderFont,
                            isDarkMode: settingVM.isDarkMode
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
                        
                        HStack {
                            if passwordText.isEmpty {
                                Text("At least 8 characters and not contain special symbols")
                                    .font(authVM.captionFont )
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                            } else {
                                if !authVM.isValidPassword {
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
                            titleFont: authVM.textFieldTitleFont,
                            textFieldSizeHeight: authVM.textFieldSizeHeight,
                            textFieldCorner: authVM.textFieldCorner,
                            textFieldBorderWidth: authVM.textFieldBorderWidth,
                            isPassword: true,
                            textFieldPlaceHolderFont: authVM.textFieldPlaceHolderFont,
                            isDarkMode: settingVM.isDarkMode
                        )
                        
                        HStack {
                            if confrimPasswordText.isEmpty {
                                Text("Re-enter your password")
                                    .font(authVM.captionFont )
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                            } else {
                                if authVM.isValidReEnterPassword {
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
                            authVM.isLoading = true
                            
                            Task {
                                try await authVM.signUp(withEmail: accountText, password: passwordText)
                                
                                authVM.isLoading = false
                                authVM.isAlert = true
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
                                        .fill(settingVM.isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                                )
                                .padding(.horizontal)
                            
                        }
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1 : 0.5)
                        .alert(isPresented: $authVM.isAlert) {
                            Alert(
                                title: Text(authVM.signUpError ? "Sign up failed" : "Sign up successfully!"),
                                message: Text(authVM.signUpError ? "The email has been used. Please register with another email" : "You have created a new account"),
                                dismissButton: .default(Text(authVM.signUpError ? "Close" : "OK")) {
                                    if (!authVM.signUpError) {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            )
                        }
                        
                        
                    }
                    
                    
                    // Push view
                    Spacer()
                }
                .foregroundColor(settingVM.isDarkMode ? .white : .black)
                .padding(.horizontal)
                
                .onChange(of: passwordText) {newValue in
                    authVM.isValidPassword = authVM.validatePasswordSignUp(newValue)
                    authVM.isValidReEnterPassword = authVM.isMatchPassword(currentPassword: newValue, reEnteredPassword: confrimPasswordText)
                }
                .onChange(of: confrimPasswordText) {newValue in
                    authVM.isValidReEnterPassword = authVM.isMatchPassword(currentPassword: passwordText, reEnteredPassword: newValue)
                }
                
                if authVM.isLoading {
                    Color.gray.opacity(0.3).ignoresSafeArea()
                    ProgressView("Loading...")
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .background(settingVM.isDarkMode ? .black : .white)
    }
}


extension SignUp: SignUpFormProtocol{
    var formIsValid: Bool{
        return accountText.contains("@") && !accountText.isEmpty && authVM.isValidPassword && authVM.isValidReEnterPassword
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp().environmentObject(AuthenticationViewModel())
    }
}
