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
    @ObservedObject var authVM = AuthenticationViewModel()
    
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
                    titleFont: .title3,
                    textFieldSizeHeight: proxy.size.height/13,
                    textFieldCorner: proxy.size.width/40,
                    textFieldBorderWidth: 1,
                    isPassword: true,
                    textFieldPlaceHolderFont: .body,
                    isDarkMode: settingVM.isDarkMode
                )
                .padding(.bottom)
                .onChange(of: currentPassword) { _ in
                    if settingVM.isSecuritySettingChange(currentPassword: currentPassword, newPassword: newPassword, isBioMetric: isFaceId) {
                        settingVM.isSecuritySettingChange = true
                    } else {
                        settingVM.isSecuritySettingChange = false
                    }
                    
                }
                
                CustomTextField(
                    text: $newPassword,
                    textFieldTitle: "New Password",
                    testFieldPlaceHolder: "Password",
                    titleFont: .title3,
                    textFieldSizeHeight: proxy.size.height/13,
                    textFieldCorner: proxy.size.width/40,
                    textFieldBorderWidth: 1,
                    isPassword: true,
                    textFieldPlaceHolderFont: .body,
                    isDarkMode: settingVM.isDarkMode
                )
                .padding(.bottom)
                .onChange(of: newPassword) { _ in
                    if settingVM.isSecuritySettingChange(currentPassword: currentPassword, newPassword: newPassword, isBioMetric: isFaceId) {
                        settingVM.isSecuritySettingChange = true
                    } else {
                        settingVM.isSecuritySettingChange = false
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
                        .onChange(of: isFaceId) { _ in
                            if settingVM.isSecuritySettingChange(currentPassword: currentPassword, newPassword: newPassword, isBioMetric: isFaceId) {
                                settingVM.isSecuritySettingChange = true
                            } else {
                                settingVM.isSecuritySettingChange = false
                            }
                        }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: { settingVM.isSecuritySettingChange.toggle() }) {
                        Text("Confirm")
                            .foregroundColor(settingVM.isSecuritySettingChange ? .white : .gray)
                            .padding()
                            .frame(width: proxy.size.width/1.2) // Make the button as wide as the HStack
                            .background(settingVM.isSecuritySettingChange ? Color.blue : Color.gray.opacity(0.5))
                            .cornerRadius(8)
                    }
                    .disabled(!settingVM.isSecuritySettingChange) // Disable when no changes
                    
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
