//
//  EditSecurityField.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 11/09/2023.
//

import SwiftUI

struct EditSecurityField: View {
    @ObservedObject var settingVM = SettingViewModel()
    @State var currentPassword = ""
    @State var newPassword = ""
    @State var isPasswordVisible = false
    @State private var isChanged = false // Track changes in fields
    @State var isFaceId = false
//    @ObservedObject var authVM = AuthenticationViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .leading) {
                HStack {
                    Spacer()
                    
                    Text("Password & Security")
                        .bold()
                        .font(.title)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                
                Text("Change Password")
                    .bold()
                    .font(.title2)
                    .padding()
                
                CustomTextField(
                    text: $currentPassword,
                    textFieldTitle: "New Password",
                    testFieldPlaceHolder: "Password",
                    titleFont: .constant(.title3),
                    textFieldSizeHeight: .constant(proxy.size.height/13),
                    textFieldCorner: .constant(proxy.size.width/40),
                    textFieldBorderWidth: .constant(1),
                    isPassword: .constant(true),
                    textFieldPlaceHolderFont: .constant(.body),
                    isDarkMode: $settingVM.isDarkMode
                )
                .padding(.bottom)
                .onChange(of: currentPassword) { _ in
                    if currentPassword == "" {
                        isChanged = false
                    } else {
                        // Update the change flag when the newPassword changes
                        isChanged = true
                    }
                    
                }
                
                CustomTextField(
                    text: $newPassword,
                    textFieldTitle: "New Password",
                    testFieldPlaceHolder: "Password",
                    titleFont: .constant(.title3),
                    textFieldSizeHeight: .constant(proxy.size.height/13),
                    textFieldCorner: .constant(proxy.size.width/40),
                    textFieldBorderWidth: .constant(1),
                    isPassword: .constant(true),
                    textFieldPlaceHolderFont: .constant(.body),
                    isDarkMode: $settingVM.isDarkMode
                )
                .padding(.bottom)
                .onChange(of: newPassword) { _ in
                    if newPassword == "" {
                        isChanged = false
                    } else {
                        // Update the change flag when the newPassword changes
                        isChanged = true
                    }
                    
                }
                
                Text("Autofill")
                    .bold()
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.top)
                
                HStack {
                    Image(systemName: "faceid")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: proxy.size.width/12)

                    Text("Face ID")
                        .font(.title3)
                    
                    Spacer()
                    
                    Toggle("", isOn: $settingVM.isFaceId)
                        .padding(.bottom)
                        .onChange(of: settingVM.isFaceId) { _ in
                            if isFaceId != settingVM.isFaceId {
                                isChanged = true
                            } else {
                                isChanged = false
                            }
                        }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: { isChanged.toggle() }) {
                            Text("Confirm")
                                .foregroundColor(isChanged ? .white : .gray)
                                .padding()
                                .frame(width: proxy.size.width/1.2) // Make the button as wide as the HStack
                                .background(isChanged ? Color.blue : Color.gray.opacity(0.5))
                                .cornerRadius(8)
                        }
                    .disabled(!isChanged) // Disable when no changes
                    
                    Spacer()
                }
                .padding(.bottom)
                
                
                HStack {
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Delete Account")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                                
                Spacer()
            }
            .foregroundColor(settingVM.isDarkMode ? .white : .black)
            .background(!settingVM.isDarkMode ? .white : .black)
        }
    }
}

struct EditSecurityField_Previews: PreviewProvider {
    static var previews: some View {
        EditSecurityField()
    }
}
