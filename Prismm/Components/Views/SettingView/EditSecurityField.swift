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
import Firebase

struct EditSecurityField: View {
    // Control state
//    @Binding var currentUser:User
//    @Binding var userSetting:UserSetting
    
    @ObservedObject var settingVM:SettingViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tabVM: TabBarViewModel
    
    @State var isGoogleSignIn: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            
            ZStack{
                
                
                
                VStack (alignment: .leading) {
                    HStack {
                        Spacer()
                        
                        // Title
                        Text("Password & Security")
                            .bold()
                            .font(.title)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    
                    // Change password
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
                        isDarkModeEnabled: tabVM.userSetting.darkModeEnabled
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
                        isDarkModeEnabled: tabVM.userSetting.darkModeEnabled
                    )
                    .padding(.bottom)
                    .onChange(of: settingVM.changePasswordNewPassword) { _ in
                        if settingVM.checkSecuritySettingChange() {
                            settingVM.hasSecuritySettingChanged = true
                        } else {
                            settingVM.hasSecuritySettingChanged = false
                        }
                        
                    }
                    
                    // Biometrics
                    Text("Login with FaceId")
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
                        
                        // Push view
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
                                    await settingVM.updateSettings(userSetting: tabVM.userSetting)
                                }
                            }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    // Push view
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            Task{
                                settingVM.isUpdateProfile = true
                                
                                APIService.changePassword(withEmail: tabVM.currentUser.account!, password: settingVM.changePasswordCurrentPassword, newpassword: settingVM.changePasswordNewPassword)
                                
                                settingVM.isUpdateProfile = false
                            }
                            
                            
                            
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
                    
                    Spacer()
                }
                .foregroundColor(tabVM.userSetting.darkModeEnabled ? .white : .black)
                .background(!tabVM.userSetting.darkModeEnabled ? .white : .black)
                .onAppear{
                    isGoogleSignIn = (Auth.auth().currentUser?.providerData[0].providerID == "google.com")
                }
                .alert("Unavailable", isPresented: $isGoogleSignIn) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                            .foregroundColor(.red)
                    }
                    
                } message: {
                    Text("You are using Google account to sign in" )
                }
                
                
                if (settingVM.isUpdateProfile){
                    Color.gray
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView("Updating ...")
                }
                
            }
        }
    }
}

//struct EditSecurityField_Previews: PreviewProvider {
//    static var previews: some View {
//        EditSecurityField()
//    }
//}
