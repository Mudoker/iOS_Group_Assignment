//
//  CustomTextField.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI

struct CustomTextField: View {
    // Get input
    @Binding var text: String

    // Control state
    @State var textFieldTitle: String
    @State var testFieldPlaceHolder: String
    @State private var isPasswordVisible: Bool = false

    // Responsive
    @Binding var titleFont: Font
    @Binding var textFieldSizeHeight: CGFloat
    @Binding var textFieldCorner: CGFloat
    @Binding var textFieldBorderWidth: CGFloat
    @Binding var isPassword: Bool
    @Binding var textFieldPlaceHolderFont: Font
    @Binding var isDarkMode: Bool
    
    // ViewModel
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    @ObservedObject var settingVM = SettingViewModel()
    
    var body: some View {
            VStack (alignment: .leading) {
                // Title
                Text(LocalizedStringKey(textFieldTitle))
                    .font(titleFont)
                    .bold()
                
                // Text field
                ZStack {
                    RoundedRectangle(cornerRadius: textFieldCorner)
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: isDarkMode ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: textFieldBorderWidth)
                        .frame(height: textFieldSizeHeight)
                    
                    // If the password textfield
                    if isPassword {
                        // Hide or show password
                        if isPasswordVisible {
                            HStack {
                                TextField("", text: $text, prompt:  Text(testFieldPlaceHolder)
                                    .foregroundColor(isDarkMode ? .white.opacity(0.5) : .black.opacity(0.5)))
                                    .font(textFieldPlaceHolderFont)
                                    .padding(.horizontal)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                    .font(textFieldPlaceHolderFont)

                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                        .font(textFieldPlaceHolderFont)
                                }
                                .padding(.trailing)
                            }
                        } else {
                            HStack {
                                SecureField("", text: $text, prompt:  Text(testFieldPlaceHolder).foregroundColor(isDarkMode ? .white.opacity(0.5) : .black.opacity(0.5)))
                                    .font(textFieldPlaceHolderFont)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                    .font(textFieldPlaceHolderFont)

                                .padding(.horizontal)

                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                        .font(textFieldPlaceHolderFont)
                                }
                                .padding(.trailing)
                            }
                        }
                    } else {
                        // Username field
                        HStack {
                            TextField("", text: $text, prompt:  Text(testFieldPlaceHolder).foregroundColor(isDarkMode ? .white.opacity(0.5) : .black.opacity(0.5))
                                .font(textFieldPlaceHolderFont)
                            )
                            .padding(.horizontal)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .font(textFieldPlaceHolderFont)
                        }
                    }
                }
            }
            .foregroundColor(isDarkMode ? .white : .black)
            .padding(.horizontal)
            .onAppear {
                textFieldSizeHeight = textFieldSizeHeight
                textFieldCorner = textFieldCorner
            }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(
            text: .constant("Preview Text"), textFieldTitle: "username",
            testFieldPlaceHolder: "Username or email", titleFont: .constant(.headline),
            textFieldSizeHeight: .constant(40.0),
            textFieldCorner: .constant(10.0),
            textFieldBorderWidth: .constant(2.0), isPassword: .constant(true), textFieldPlaceHolderFont: .constant(Font.body), isDarkMode: .constant(true)
        )
    }
}
