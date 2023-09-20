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
  Last modified: 15/09/2023
  Acknowledgement: None
*/

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct SettingView : View {
    @ObservedObject var settingVM:SettingViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader{ proxy in
                ScrollView {
                        VStack (alignment: .leading, spacing: 0) {
                            // Title and search field
                            Text("Settings")
                                .font(.largeTitle)
                                .bold()
                                .padding(.bottom, 8)
                                .padding(.top)
                            
                            Button(action: {
                                if UIDevice.current.userInterfaceIdiom == .pad {
                                    settingVM.isAccountSettingSheetPresentedOniPad.toggle()
                                } else {
                                    settingVM.isAccountSettingSheetPresentedOniPhone.toggle()
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: settingVM.cornerRadius)
                                        .fill(!settingVM.isDarkModeEnabled ? .gray.opacity(0.1) : .gray.opacity(0.4))
                                        .frame(height: settingVM.accountSettingHeight)
                                    HStack {
                                        
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: settingVM.accountSettingImageWidth)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Username")
                                                .font(settingVM.accountSettingUsernameFont)
                                                .bold()
                                            
                                            Text("@huuquoc7603")
                                                .opacity(0.8)
                                                .accentColor(.white)
                                                .font(settingVM.accountSettingEmailFont)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                                .padding(.vertical)
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading) {
                                Text("System")
                                    .bold()
                                    .padding(.bottom)
                                    .font(settingVM.contentFont)
                                
                                HStack {
                                    Image(systemName: "globe.asia.australia.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: settingVM.iconSize, height: settingVM.iconSize)
                                    
                                    Text("Language")
                                        .font(settingVM.contentFont)
                                    
                                    Spacer()
                                    
                                    Picker("", selection: $settingVM.selectedLanguage) {
                                        Text("English").tag("en")
                                        Text("Vietnamese").tag("vi")
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .onChange(of: settingVM.selectedLanguage) { _ in
                                        Task{
                                            await
                                            settingVM.updateSettings()
                                        }
                                    }
                                    
                                }
                                .padding(.bottom)
                                
                                Divider()
                                    .overlay(settingVM.isDarkModeEnabled ? .gray : .gray)

                                HStack {
                                    Image(systemName: "moon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: settingVM.iconSize, height: settingVM.iconSize)
                                    Text("Dark Mode")
                                        .font(settingVM.contentFont)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $settingVM.isDarkModeEnabled)
                                        .padding(.vertical)
                                    
                                    //setting
                                        .onChange(of: settingVM.isDarkModeEnabled) { _ in
                                            Task{
                                                await
                                                settingVM.updateSettings()
                                            }
                                            
                                        }
                                }
                                .padding(.bottom)
                                
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .background(RoundedRectangle(cornerRadius: proxy.size.width/40)
                                .fill(!settingVM.isDarkModeEnabled ? .gray.opacity(0.1) : .gray.opacity(0.4))
                            )
                            .padding(.bottom)
                            
                            VStack(alignment: .leading) {
                                Text("Notification")
                                    .bold()
                                    .padding(.bottom)
                                    .font(settingVM.contentFont)
                                
                                HStack {
                                    Image(systemName: "bell")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: settingVM.iconSize, height: settingVM.iconSize)
                                    
                                    Text("Push Notification")
                                        .font(settingVM.contentFont)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $settingVM.isPushNotificationEnabled)
                                        .onChange(of: settingVM.isPushNotificationEnabled) { _ in
                                            Task{
                                                await
                                                settingVM.updateSettings()
                                            }
                                            
                                        }
                                }
                                .padding(.bottom)
                                
                                
                                Divider()
                                    .overlay(settingVM.isDarkModeEnabled ? .gray : .gray)

                                HStack {
                                    Image(systemName: "message")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: settingVM.iconSize, height: settingVM.iconSize)
                                    
                                    Text("Message Notification")
                                        .font(settingVM.contentFont)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $settingVM.isMessageNotificationEnabled)
                                        .padding(.vertical)
                                        .onChange(of: settingVM.isMessageNotificationEnabled) { _ in
                                            Task{
                                                await
                                                settingVM.updateSettings()
                                            }
                                            
                                        }
                                }
                                .padding(.bottom)
                                
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .background(RoundedRectangle(cornerRadius: proxy.size.width/40)
                                .fill(!settingVM.isDarkModeEnabled ? .gray.opacity(0.1) : .gray.opacity(0.4))
                            )
                            .padding(.bottom)
                            
                            VStack(alignment: .leading) {
                                Text("Social")
                                    .bold()
                                    .padding(.bottom)
                                    .font(settingVM.contentFont)
                                
                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "person.crop.circle.badge.xmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: settingVM.iconSize, height: settingVM.iconSize)
                                        
                                        Text("Blocked")
                                            .font(settingVM.contentFont)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.right.square")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: settingVM.iconSize, height: settingVM.iconSize)
                                    }
                                    .padding(.bottom)
                                }
                                
                                Divider()
                                    .overlay(settingVM.isDarkModeEnabled ? .gray : .gray)

                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "rectangle.portrait.slash")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: settingVM.iconSize, height: settingVM.iconSize)
                                        
                                        Text("Hide content from")
                                            .font(settingVM.contentFont)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.right.square")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: settingVM.iconSize, height: settingVM.iconSize)
                                            .padding(.vertical)
                                    }
                                }
                                .padding(.bottom)
                                
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .background(RoundedRectangle(cornerRadius: proxy.size.width/40)
                                .fill(!settingVM.isDarkModeEnabled ? .gray.opacity(0.1) : .gray.opacity(0.4))
                            )
                            .padding(.bottom)
                            
                            VStack(alignment: .leading) {
                                Text("Info")
                                    .bold()
                                    .padding(.bottom)
                                    .font(settingVM.contentFont)
                                
                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "info.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: settingVM.iconSize, height: settingVM.iconSize)
                                        
                                        Text("About us")
                                            .font(settingVM.contentFont)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.right.square")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: settingVM.iconSize, height: settingVM.iconSize)
                                            .padding(.vertical)
                                    }
                                    .padding(.bottom)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .background(RoundedRectangle(cornerRadius: proxy.size.width/40)
                                .fill(!settingVM.isDarkModeEnabled ? .gray.opacity(0.1) : .gray.opacity(0.4))
                            )
                            .padding(.bottom)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Button(action: {settingVM.isSignOutAlertPresented.toggle()}) {
                                    Text("Sign Out")
                                        .foregroundColor(.red)
                                        .bold()
                                        .font(settingVM.signOutButtonTextFont)
                                        .padding(.vertical)
                                }
                                .alert("Logout", isPresented: $settingVM.isSignOutAlertPresented) {
                                    Button("Cancel", role: .cancel) {
                                    }
                                    Button("Sign Out", role: .destructive) {
                                        Task{
                                            try Auth.auth().signOut()
                                        }
                                        
                                    }
                                } message: {
                                    Text("\nConfirm Sign Out?")
                                }
                                Spacer()
                            }
                            
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $settingVM.isAccountSettingSheetPresentedOniPad) {
                            NavigationView {
                                SettingSheet(isSheetPresented: $settingVM.isAccountSettingSheetPresentedOniPad, settingVM: settingVM)
                            }
                        }
                        .fullScreenCover(isPresented: $settingVM.isAccountSettingSheetPresentedOniPhone) {
                            NavigationView {
                                SettingSheet(isSheetPresented: $settingVM.isAccountSettingSheetPresentedOniPhone, settingVM: settingVM)
                            }
                        }
                        .onAppear {
                            settingVM.proxySize = proxy.size
                            //set uid
                            Constants.currentUserID = "m52oyZNbCxVx5SsvFAEPwankeAP2"
                        }
                }
            }
            .foregroundColor(settingVM.isDarkModeEnabled ? .white : .black)
            .background(!settingVM.isDarkModeEnabled ? .white : .black)
        }
    }
}

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView()
//    }
//}
