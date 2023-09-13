//
//  SettingView.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 09/09/2023.
//

import Foundation
import SwiftUI

struct SettingView : View {
    @State private var name = "Quang Anh"
    @State private var isRePassword = ""
    @State private var password : Bool = false
    @State private var rePassword : Bool = false
    @State private var isChange = true
    @State private var isCancel = false
    @State private var isChangeUserName = true
    @State private var isCancelUserName = false
    //    @AppStorage("password") private var isPassword = ""
    @State private var isPassword = "12345"
    @State private var searchText = ""
    @State private var isSheetPresented = false
    var languages = ["English, Vietnamese"]
    @State private var isShowingSignOutAlert = false
    @State private var isSignOut = false
    @ObservedObject var authenVM = AuthenticationViewModel()
    @StateObject var settingVM = SettingViewModel()
    
    @State private var cornerRadiusSize: CGFloat = 0
    @State private var accountSettingSizeHeight: CGFloat = 0
    @State private var accountSettingImageSizeWidth: CGFloat = 0
    @State private var accountSettingUsernameFont: Font = .title3
    @State private var accountSettingEmailFont: Font = .body
    @State private var contentFont: Font = .body
    @State private var imageSize: CGFloat = 0
    @State private var signOutText: Font = .title

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
                            
                            Button(action: {isSheetPresented.toggle()}) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: cornerRadiusSize)
                                        .fill(!settingVM.isDarkMode ? .gray.opacity(0.1) : .gray.opacity(0.4))
                                        .frame(height: accountSettingSizeHeight)
                                        .onAppear {
                                            print(accountSettingSizeHeight)
                                        }
                                    HStack {
                                        
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: accountSettingImageSizeWidth)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Quoc Doan")
                                                .font(accountSettingUsernameFont)
                                                .bold()
                                            
                                            Text("@huuquoc7603")
                                                .opacity(0.8)
                                                .accentColor(.white)
                                                .font(accountSettingEmailFont)
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
                                    .font(contentFont)
                                
                                HStack {
                                    Image(systemName: "globe.asia.australia.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: imageSize, height: imageSize)
                                    
                                    Text("Language")
                                        .font(contentFont)
                                    
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
                                        .frame(width: imageSize, height: imageSize)
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
                                    .font(contentFont)
                                
                                HStack {
                                    Image(systemName: "bell")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: imageSize, height: imageSize)
                                    
                                    Text("Push Notification")
                                        .font(contentFont)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $settingVM.isPushNotification)
                                }
                                .padding(.bottom)
                                
                                
                                Divider()
                                
                                HStack {
                                    Image(systemName: "message")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: imageSize, height: imageSize)
                                    
                                    Text("Message Notification")
                                        .font(contentFont)
                                    
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
                                    .font(contentFont)
                                
                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "person.crop.circle.badge.xmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: imageSize, height: imageSize)
                                        
                                        Text("Blocked")
                                            .font(contentFont)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.right.square")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: imageSize, height: imageSize)
                                    }
                                    .padding(.bottom)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "rectangle.portrait.slash")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: imageSize, height: imageSize)
                                        
                                        Text("Hide story from")
                                            .font(settingVM.contentFont)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.right.square")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: imageSize, height: imageSize)
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
                                    .font(contentFont)
                                
                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "info.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: imageSize, height: imageSize)
                                        
                                        Text("About us")
                                            .font(contentFont)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.right.square")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: imageSize, height: imageSize)
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
                                Button(action: {isShowingSignOutAlert.toggle()}) {
                                    Text("Sign Out")
                                        .foregroundColor(.red)
                                        .bold()
                                        .font(settingVM.signOutText)
                                        .padding(.vertical)
                                }
                                .alert(isPresented: $isShowingSignOutAlert) {
                                    Alert(
                                        title: Text("Sign Out"),
                                        message: Text("Are you sure you want to sign out?"),
                                        primaryButton: .default(
                                            Text("Sign Out")
                                        ) {
                                            isSignOut.toggle()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                    
                                }
                                Spacer()
                            }
                            
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $isSheetPresented) {
                            NavigationView {
                                SettingSheet(isSheetPresented: $isSheetPresented, settingVM: settingVM)
                            }
                        }
                        .onAppear {
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                self.cornerRadiusSize = proxy.size.width/40
                                self.accountSettingSizeHeight = proxy.size.width/4
                                self.accountSettingImageSizeWidth = proxy.size.width / 8
                                self.accountSettingUsernameFont = .title3
                                self.accountSettingEmailFont = .body
                                self.contentFont = .body
                                self.imageSize = proxy.size.width/18
                                self.signOutText = .title
                            } else {
                                self.cornerRadiusSize = proxy.size.width/50
                                self.accountSettingSizeHeight = proxy.size.height/8
                                self.accountSettingImageSizeWidth = proxy.size.width/12
                                self.accountSettingUsernameFont = .title
                                self.accountSettingEmailFont = .body
                                self.contentFont = .title3
                                self.imageSize = proxy.size.width / 28
                                self.signOutText = .title
                            }
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
