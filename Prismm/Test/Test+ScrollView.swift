//
//  SettingView.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 09/09/2023.
//

import Foundation
import SwiftUI

struct Test_SettingView : View {
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
    @State private var size : CGFloat = 0
    var languages = ["English, Vietnamese"]
    @State private var isShowingSignOutAlert = false
    @State private var isSignOut = false
    @ObservedObject var authenVM = AuthenticationViewModel()
    @StateObject var settingVM = SettingViewModel()

    var body: some View {
        NavigationStack {
            GeometryReader{ proxy in
                ScrollView {
                    let size = settingVM.accountSettingSizeHeight
                        VStack (alignment: .leading, spacing: 0) {
                            // Title and search field
                            Text("Settings")
                                .font(.largeTitle)
                                .bold()
                                .padding(.bottom, 8)
                                .padding(.top)
                            
                            Button(action: {isSheetPresented.toggle()}) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: settingVM.cornerRadiusSize)
                                        .fill(!settingVM.isDarkMode ? .gray.opacity(0.1) : .gray.opacity(0.4))
                                        .frame(height: settingVM.accountSettingSizeHeight)
                                        .onAppear {
                                            print(settingVM.accountSettingSizeHeight)
                                        }
                                    HStack {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width:UIDevice.current.userInterfaceIdiom == .phone ? self.size : 500)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Quoc Doan")
                                                .font( settingVM.accountSettingUsernameFont)
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
                           
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $isSheetPresented) {
                            NavigationView {
                                SettingSheet(isSheetPresented: $isSheetPresented, settingVM: settingVM)
                            }
                        }
                        .foregroundColor(settingVM.isDarkMode ? .white : .black)
                        .background(!settingVM.isDarkMode ? .white : .black)
                        .onAppear {
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                self.size = 100
                                settingVM.cornerRadiusSize = proxy.size.width/40
                                settingVM.accountSettingSizeHeight = 100
                                settingVM.accountSettingImageSizeWidth = proxy.size.width/10
                                settingVM.accountSettingUsernameFont = .title3
                                settingVM.accountSettingEmailFont = .body
                                settingVM.contentFont = .body
                                settingVM.imageSize = 100
                            } else {
                                settingVM.cornerRadiusSize = proxy.size.width/50
                                settingVM.accountSettingSizeHeight = proxy.size.height/8
                                settingVM.accountSettingImageSizeWidth = proxy.size.width/12
                                settingVM.accountSettingUsernameFont = .title
                                settingVM.accountSettingEmailFont = .body
                                settingVM.contentFont = .title3
                                settingVM.imageSize = proxy.size.width / 28
                                settingVM.signOutText = .title
                            }
                        }
                   
                }
                
            }
        }
    }
}

struct Test_SettingView_Previews: PreviewProvider {
    static var previews: some View {
        Test_SettingView()
    }
}
