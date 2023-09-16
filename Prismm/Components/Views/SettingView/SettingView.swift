//
//  SettingView.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 09/09/2023.
//

import Foundation
import SwiftUI

struct SettingView : View {
    @StateObject var settingVM = SettingViewModel()
    
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
                                    settingVM.isAccountSettingSheetPresentedIpad.toggle()
                                } else {
                                    settingVM.isAccountSettingSheetPresentedIphone.toggle()
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: settingVM.cornerRadiusSize)
                                        .fill(!settingVM.isDarkMode ? .gray.opacity(0.1) : .gray.opacity(0.4))
                                        .frame(height: settingVM.accountSettingSizeHeight)
                                    HStack {
                                        
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: settingVM.accountSettingImageSizeWidth)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Quoc Doan")
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
                                        .frame(width: settingVM.imageSize, height: settingVM.imageSize)
                                    
                                    Text("Language")
                                        .font(settingVM.contentFont)
                                    
                                    Spacer()
                                    
                                    Picker("", selection: $settingVM.language) {
                                        Text("English").tag("en")
                                        Text("Vietnamese").tag("vi")
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    
                                }
                                .padding(.bottom)
                                
                                Divider()
                                
                                HStack {
                                    Image(systemName: "moon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: settingVM.imageSize, height: settingVM.imageSize)
                                    Text("Dark Mode")
                                        .font(settingVM.contentFont)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $settingVM.isDarkMode)
                                        .padding(.vertical)
                                }
                                .padding(.bottom)
                                
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .background(RoundedRectangle(cornerRadius: proxy.size.width/40)
                                .fill(!settingVM.isDarkMode ? .gray.opacity(0.1) : .gray.opacity(0.4))
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
                                        .frame(width: settingVM.imageSize, height: settingVM.imageSize)
                                    
                                    Text("Push Notification")
                                        .font(settingVM.contentFont)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $settingVM.isPushNotification)
                                }
                                .padding(.bottom)
                                
                                
                                Divider()
                                
                                HStack {
                                    Image(systemName: "message")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: settingVM.imageSize, height: settingVM.imageSize)
                                    
                                    Text("Message Notification")
                                        .font(settingVM.contentFont)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $settingVM.isMessageNotification)
                                        .padding(.vertical)
                                }
                                .padding(.bottom)
                                
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .background(RoundedRectangle(cornerRadius: proxy.size.width/40)
                                .fill(!settingVM.isDarkMode ? .gray.opacity(0.1) : .gray.opacity(0.4))
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
                                            .frame(width: settingVM.imageSize, height: settingVM.imageSize)
                                        
                                        Text("Blocked")
                                            .font(settingVM.contentFont)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.right.square")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: settingVM.imageSize, height: settingVM.imageSize)
                                    }
                                    .padding(.bottom)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "rectangle.portrait.slash")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: settingVM.imageSize, height: settingVM.imageSize)
                                        
                                        Text("Hide content from")
                                            .font(settingVM.contentFont)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.right.square")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: settingVM.imageSize, height: settingVM.imageSize)
                                            .padding(.vertical)
                                    }
                                }
                                .padding(.bottom)
                                
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .background(RoundedRectangle(cornerRadius: proxy.size.width/40)
                                .fill(!settingVM.isDarkMode ? .gray.opacity(0.1) : .gray.opacity(0.4))
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
                                            .frame(width: settingVM.imageSize, height: settingVM.imageSize)
                                        
                                        Text("About us")
                                            .font(settingVM.contentFont)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.right.square")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: settingVM.imageSize, height: settingVM.imageSize)
                                            .padding(.vertical)
                                    }
                                    .padding(.bottom)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .background(RoundedRectangle(cornerRadius: proxy.size.width/40)
                                .fill(!settingVM.isDarkMode ? .gray.opacity(0.1) : .gray.opacity(0.4))
                            )
                            .padding(.bottom)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Button(action: {settingVM.isShowingSignOutAlert.toggle()}) {
                                    Text("Sign Out")
                                        .foregroundColor(.red)
                                        .bold()
                                        .font(settingVM.signOutText)
                                        .padding(.vertical)
                                }
                                .alert("Logout", isPresented: $settingVM.isShowingSignOutAlert) {
                                    Button("Cancel", role: .cancel) {
                                    }
                                    Button("Sign Out", role: .destructive) {
                                    }
                                } message: {
                                    Text("Are you sure?")
                                }
                                Spacer()
                            }
                            
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $settingVM.isAccountSettingSheetPresentedIpad) {
                            NavigationView {
                                SettingSheet(isSheetPresented: $settingVM.isAccountSettingSheetPresentedIpad, settingVM: settingVM)
                            }
                        }
                        .fullScreenCover(isPresented: $settingVM.isAccountSettingSheetPresentedIphone) {
                            NavigationView {
                                SettingSheet(isSheetPresented: $settingVM.isAccountSettingSheetPresentedIphone, settingVM: settingVM)
                            }
                        }
                        .onAppear {
                            settingVM.proxySize = proxy.size
                        }
                }
            }
            .foregroundColor(settingVM.isDarkMode ? .white : .black)
            .background(!settingVM.isDarkMode ? .white : .black)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
