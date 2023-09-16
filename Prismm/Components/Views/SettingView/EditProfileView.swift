//
//  EditProfileView.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 11/09/2023.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var settingVM = SettingViewModel()
    @State var accountText: String = ""
    @State var usernameText: String = ""
    @State var phoneNumberText: String = ""
    @State var facebookLink: String = ""
    @State var gmailLink: String = ""
    @State var linkedInLink: String = ""
    
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
                                
                                TextField("", text: $usernameText, prompt: Text(verbatim: "qdoan7603").foregroundColor(settingVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: usernameText) { _ in
                                        if settingVM.isProfileSettingChange(username: usernameText, phoneNumber: phoneNumberText, fb: facebookLink, gmail: gmailLink, ld: linkedInLink) {
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
                                
                                TextField("", text: $phoneNumberText, prompt: Text(verbatim: "qdoan7603").foregroundColor(settingVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: phoneNumberText) { _ in
                                        if settingVM.isProfileSettingChange(username: usernameText, phoneNumber: phoneNumberText, fb: facebookLink, gmail: gmailLink, ld: linkedInLink) {
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
                                
                                TextField("", text: $facebookLink, prompt: Text(verbatim: "example.com").foregroundColor(settingVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: facebookLink) { _ in
                                        if settingVM.isProfileSettingChange(username: usernameText, phoneNumber: phoneNumberText, fb: facebookLink, gmail: gmailLink, ld: linkedInLink) {
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
                                
                                TextField("", text: $gmailLink, prompt: Text(verbatim: "example.com").foregroundColor(settingVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: gmailLink) { _ in
                                        if settingVM.isProfileSettingChange(username: usernameText, phoneNumber: phoneNumberText, fb: facebookLink, gmail: gmailLink, ld: linkedInLink) {
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
                                
                                TextField("", text: $linkedInLink, prompt: Text(verbatim: "example.com").foregroundColor(settingVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: linkedInLink) { _ in
                                        if settingVM.isProfileSettingChange(username: usernameText, phoneNumber: phoneNumberText, fb: facebookLink, gmail: gmailLink, ld: linkedInLink) {
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
                                    if settingVM.isValidProfileURL(facebookLink, platform: "fb") {
                                        settingVM.isChangeProfile.toggle()
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
