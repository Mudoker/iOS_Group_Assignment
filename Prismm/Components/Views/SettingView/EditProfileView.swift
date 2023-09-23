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

struct EditProfileView: View {
    // Control state
    @Binding var currentUser:User
    @Binding var userSetting:UserSetting
    @ObservedObject var settingVM:SettingViewModel
    @State var accountText: String = ""
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    // Title
                    Text("Profile Settings")
                        .bold()
                        .font(.title)
                        .padding(.horizontal)
                    
                    // Change avatar
                    VStack(alignment: .center) {
                        Button(action: {}) {
                            Image("testAvt")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: proxy.size.width / 4, height: proxy.size.width / 4)
                                .clipShape(Circle())
                                .overlay(
                                    ZStack {
                                        Circle()
                                            .fill(Color.black.opacity(0.6))
                                        
                                        Image(systemName: "camera")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: proxy.size.width / 12)
                                    }
                                )
                        }
                        Text("Change photo")
                    }
                    .padding()
                    
                    // Content
                    VStack(alignment: .leading) { // Align text to the left
                        Text("Update profile")
                            .padding(.vertical)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Profile")
                                .bold()
                            
                            HStack {
                                Text("Account")
                                
                                Spacer()
                                
                                Text(verbatim: "huuquoc7603@gmail.com")
                                    .foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3))
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Text("Username")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.newProfileUsername, prompt: Text(verbatim: "qdoan7603").foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.newProfileUsername) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.hasProfileSettingChanged = true
                                        } else {
                                            settingVM.hasProfileSettingChanged = false
                                            
                                        }
                                    }
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Text("Phone number")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.newProfilePhoneNumber, prompt: Text(verbatim: "qdoan7603").foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.newProfilePhoneNumber) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.hasProfileSettingChanged = true
                                        } else {
                                            settingVM.hasProfileSettingChanged = false
                                            
                                        }
                                    }
                                
                            }
                            .padding(.vertical)
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        
                        // Connections
                        VStack(alignment: .leading) {
                            Text("Connections")
                                .bold()
                            
                            HStack {
                                Image("fb")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: proxy.size.width/15, height: proxy.size.width/15)
                                
                                Text("Facebook")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.newProfileFacebook, prompt: Text(verbatim: "example.com").foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.newProfileFacebook) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.hasProfileSettingChanged = true
                                        } else {
                                            settingVM.hasProfileSettingChanged = false
                                            
                                        }
                                    }
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Image("mail")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: proxy.size.width/15, height: proxy.size.width/15)
                                
                                Text("Email")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.newProfileGmail, prompt: Text(verbatim: "example.com").foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.newProfileGmail) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.hasProfileSettingChanged = true
                                        } else {
                                            settingVM.hasProfileSettingChanged = false
                                            
                                        }
                                    }
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Image("linkedin")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: proxy.size.width/15, height: proxy.size.width/15)
                                
                                Text("LinkedIn")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.newProfileLinkedIn, prompt: Text(verbatim: "example.com").foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.newProfileLinkedIn) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.hasProfileSettingChanged = true
                                        } else {
                                            settingVM.hasProfileSettingChanged = false
                                            
                                        }
                                    }
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    //MARK: Update Profile
                                    Task{
                                        await settingVM.updateProfile()
                                        settingVM.hasProfileSettingChanged.toggle()
                                        settingVM.resetField()
                                    }
                                    
                                    
                                }) {
                                    Text("Confirm")
                                        .foregroundColor(settingVM.isProfileSettingChange() ? .white : .gray)
                                        .padding()
                                        .frame(width: proxy.size.width/1.2) // Make the button as wide as the HStack
                                        .background(settingVM.hasProfileSettingChanged ? Color.blue : Color.gray.opacity(0.5))
                                        .cornerRadius(8)
                                }
                                .disabled(!settingVM.hasProfileSettingChanged) // Disable when no changes
                                .padding(.top)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        
                    }
                }
            }
            .padding(.top, 0.1)
        }
        .foregroundColor(userSetting.darkModeEnabled ? .white : .black)
        .background(!userSetting.darkModeEnabled ? .white : .black)
    }
}

//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView(, settingVM: <#SettingViewModel#>)
//    }
//}
