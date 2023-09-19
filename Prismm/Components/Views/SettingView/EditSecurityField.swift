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

  Created  date: 11/09/2023
  Last modified: 15/09/2023
  Acknowledgement: None
*/

import SwiftUI

struct EditSecurityField: View {
    @ObservedObject var settingVM = SettingViewModel()
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
                    text: $settingVM.changePasswordCurrentPassword,
                    textFieldTitle: "Current Password",
                    testFieldPlaceHolder: "Current Password",
                    titleFont: .title3,
                    textFieldSizeHeight: proxy.size.height/13,
                    textFieldCorner: proxy.size.width/40,
                    textFieldBorderWidth: 1,
                    isPassword: true,
                    textFieldPlaceHolderFont: .body,
                    isDarkModeEnabled: settingVM.isDarkModeEnabled
                )
                .padding(.bottom)
                .onChange(of: settingVM.changePasswordNewPassword) { _ in
                    if settingVM.checkSecuritySettingChange(){
                        settingVM.hasSecuritySettingChanged = true
                    } else {
                        settingVM.hasSecuritySettingChanged = false
                    }
                    
                }
                
                CustomTextField(
                    text: $settingVM.changePasswordNewPassword,
                    textFieldTitle: "New Password",
                    testFieldPlaceHolder: "New Password",
                    titleFont: .title3,
                    textFieldSizeHeight: proxy.size.height/13,
                    textFieldCorner: proxy.size.width/40,
                    textFieldBorderWidth: 1,
                    isPassword: true,
                    textFieldPlaceHolderFont: .body,
                    isDarkModeEnabled: settingVM.isDarkModeEnabled
                )
                .padding(.bottom)
                .onChange(of: settingVM.changePasswordNewPassword) { _ in
                    if settingVM.checkSecuritySettingChange() {
                        settingVM.hasSecuritySettingChanged = true
                    } else {
                        settingVM.hasSecuritySettingChanged = false
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
                    
                    Toggle("", isOn: $settingVM.isFaceIdEnabled)
                        .padding(.bottom)
                        .onChange(of: settingVM.isFaceIdEnabled) { _ in
                            if settingVM.checkSecuritySettingChange() {
                                settingVM.hasSecuritySettingChanged = true
                            } else {
                                settingVM.hasSecuritySettingChanged = false
                            }
                            Task{
                                await settingVM.updateSettings(forUserID: Constants.currentUserID)
                            }
                        }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
                        settingVM.hasSecuritySettingChanged.toggle()

                    }) {
                        Text("Confirm")
                            .foregroundColor(settingVM.hasSecuritySettingChanged ? .white : .gray)
                            .padding()
                            .frame(width: proxy.size.width/1.2) // Make the button as wide as the HStack
                            .background(settingVM.hasSecuritySettingChanged ? Color.blue : Color.gray.opacity(0.5))
                            .cornerRadius(8)
                    }
                    .disabled(!settingVM.hasSecuritySettingChanged) // Disable when no changes
                    
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
            .foregroundColor(settingVM.isDarkModeEnabled ? .white : .black)
            .background(!settingVM.isDarkModeEnabled ? .white : .black)
        }
    }
}

struct EditSecurityField_Previews: PreviewProvider {
    static var previews: some View {
        EditSecurityField()
    }
}
