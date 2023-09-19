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
                    Image(settingVM.isDarkModeEnabled ? Constants.darkThemeAppLogo : Constants.lightThemeAppLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: authVM.logoImageSize, height: 0)
                        .padding(.vertical, authVM.imageVerticalPadding)
                    
                    // Title
                    Text ("Sign Up")
                        .font(.system(size: authVM.titleFontSize))
                        .bold()
                    
                    Text("Create a new profile")
                        .font(authVM.captionFont)
                        .bold()
                        .opacity(0.7)
                    
                    // Text field
                    VStack {
                        CustomTextField(
                            text: $authVM.signUpAccountText,
                            textFieldTitle: "Email",
                            testFieldPlaceHolder: "Gmail Account",
                            titleFont: authVM.textFieldTitleFont,
                            textFieldSizeHeight: authVM.textFieldSizeHeight,
                            textFieldCorner: authVM.textFieldCornerRadius,
                            textFieldBorderWidth: authVM.textFieldBorderWidth,
                            isPassword: false,
                            textFieldPlaceHolderFont: authVM.textFieldPlaceHolderFont,
                            isDarkModeEnabled: settingVM.isDarkModeEnabled
                        )
                        .padding(.bottom)
                        
                        
                        CustomTextField(
                            text: $authVM.signUpPasswordText,
                            textFieldTitle: "Password",
                            testFieldPlaceHolder: "Password",
                            titleFont: authVM.textFieldTitleFont,
                            textFieldSizeHeight: authVM.textFieldSizeHeight,
                            textFieldCorner: authVM.textFieldCornerRadius,
                            textFieldBorderWidth: authVM.textFieldBorderWidth,
                            isPassword: true,
                            textFieldPlaceHolderFont: authVM.textFieldPlaceHolderFont,
                            isDarkModeEnabled: settingVM.isDarkModeEnabled
                        )
                        
                        HStack {
                            if authVM.signUpPasswordText.isEmpty {
                                Text("At least 6 characters and not contain special symbols")
                                    .font(authVM.captionFont)
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                            } else {
                                if !authVM.isPasswordValid {
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
                            text: $authVM.signUpReEnterPasswordText,
                            textFieldTitle: "Confirm Password",
                            testFieldPlaceHolder: "Password",
                            titleFont: authVM.textFieldTitleFont,
                            textFieldSizeHeight: authVM.textFieldSizeHeight,
                            textFieldCorner: authVM.textFieldCornerRadius,
                            textFieldBorderWidth: authVM.textFieldBorderWidth,
                            isPassword: true,
                            textFieldPlaceHolderFont: authVM.textFieldPlaceHolderFont,
                            isDarkModeEnabled: settingVM.isDarkModeEnabled
                        )
                        
                        HStack {
                            if authVM.signUpReEnterPasswordText.isEmpty {
                                Text("Re-enter your password")
                                    .font(authVM.captionFont )
                                    .padding(.bottom, 5)
                                    .opacity(0.7)
                            } else {
                                if authVM.isReenteredPasswordValid {
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
                            authVM.isFetchingData = true
                            
                            Task {
                                try await authVM.createNewUser(withEmail: authVM.signUpAccountText, password: authVM.signUpPasswordText)
                                
                                authVM.isFetchingData = false
                                authVM.isAlertPresent = true
                            }
                        }) {
                            Text("Sign Up")
                                .foregroundColor(.white)
                                .font(authVM.loginTextFont)
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: authVM.loginButtonHeight)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(settingVM.isDarkModeEnabled ? Constants.darkThemeColor : Constants.lightThemeColor)
                                )
                                .padding(.horizontal)
                            
                        }
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1 : 0.5)
                        .alert(isPresented: $authVM.isAlertPresent) {
                            Alert(
                                title: Text(authVM.hasSignUpError ? "Sign up failed" : "Sign up successfully!"),
                                message: Text(authVM.hasSignUpError ? "The email has been used. Please register with another email" : "You have created a new account"),
                                dismissButton: .default(Text(authVM.hasSignUpError ? "Close" : "OK")) {
                                    if (!authVM.hasSignUpError) {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            )
                        }
                        
                        
                    }
                    
                    
                    // Push view
                    Spacer()
                }
                .foregroundColor(settingVM.isDarkModeEnabled ? .white : .black)
                .padding(.horizontal)
                
                .onChange(of: authVM.signUpPasswordText) {newValue in
                    authVM.isPasswordValid = authVM.isPasswordValidForSignUp(newValue)
                    authVM.isReenteredPasswordValid = authVM.passwordsMatch(currentPassword: newValue, reEnteredPassword: authVM.signUpReEnterPasswordText)
                }
                .onChange(of: authVM.signUpReEnterPasswordText) {newValue in
                    authVM.isReenteredPasswordValid = authVM.passwordsMatch(currentPassword: authVM.signUpPasswordText, reEnteredPassword: newValue)
                }
                
                if authVM.isFetchingData {
                    Color.gray.opacity(0.3).ignoresSafeArea()
                    ProgressView("Loading...")
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .background(settingVM.isDarkModeEnabled ? .black : .white)
    }
}


extension SignUp: SignUpFormProtocol{
    var formIsValid: Bool{
        return authVM.signUpAccountText.contains("@") && !authVM.signUpAccountText.isEmpty && authVM.isPasswordValid && authVM.isReenteredPasswordValid
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp().environmentObject(AuthenticationViewModel())
    }
}
