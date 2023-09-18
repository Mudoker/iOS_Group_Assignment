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
    @ObservedObject var settingVM = SettingViewModel()
    @State var accountText: String = ""

    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("Profile Settings")
                        .bold()
                        .font(.title)
                        .padding(.horizontal)
                    
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
                    //                .frame(maxWidth: .infinity, alignment: .center) // Center align this section
                    
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
                                    .foregroundColor(settingVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3))
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Text("Username")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.isChangeProfileUsername, prompt: Text(verbatim: "qdoan7603").foregroundColor(settingVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.isChangeProfileUsername) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.isChangeProfile = true
                                        } else {
                                            settingVM.isChangeProfile = false
                                            
                                        }
                                    }
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Text("Phone number")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.isChangeProfilePhoneNumber, prompt: Text(verbatim: "qdoan7603").foregroundColor(settingVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    
                                    .onChange(of: settingVM.isChangeProfilePhoneNumber) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.isChangeProfile = true
                                        } else {
                                            settingVM.isChangeProfile = false
                                            
                                        }
                                    }
                                
                            }
                            .padding(.vertical)
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        
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
                                
                                TextField("", text: $settingVM.isChangeProfileFB, prompt: Text(verbatim: "example.com").foregroundColor(settingVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.isChangeProfileFB) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.isChangeProfile = true
                                        } else {
                                            settingVM.isChangeProfile = false
                                            
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
                                
                                TextField("", text: $settingVM.isChangeProfileGmail, prompt: Text(verbatim: "example.com").foregroundColor(settingVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.isChangeProfileGmail) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.isChangeProfile = true
                                        } else {
                                            settingVM.isChangeProfile = false
                                            
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
                                
                                TextField("", text: $settingVM.isChangeProfileLD, prompt: Text(verbatim: "example.com").foregroundColor(settingVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.isChangeProfileLD) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.isChangeProfile = true
                                        } else {
                                            settingVM.isChangeProfile = false
                                            
                                        }
                                    }
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    if settingVM.isValidProfileURL(settingVM.isChangeProfileFB, platform: "fb") {
                                        settingVM.isChangeProfile.toggle()
                                        Task{
                                            await settingVM.updateUserData(uid: Constants.uid)
                                        }
                                        
                                        
                                    }
                                    
                                }) {
                                    Text("Confirm")
                                        .foregroundColor(settingVM.isChangeProfile ? .white : .gray)
                                        .padding()
                                        .frame(width: proxy.size.width/1.2) // Make the button as wide as the HStack
                                        .background(settingVM.isChangeProfile ? Color.blue : Color.gray.opacity(0.5))
                                        .cornerRadius(8)
                                }
                                .disabled(!settingVM.isChangeProfile) // Disable when no changes
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
        .foregroundColor(settingVM.isDarkMode ? .white : .black)
        .background(!settingVM.isDarkMode ? .white : .black)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
