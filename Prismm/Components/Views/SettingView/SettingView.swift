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
    @State var selectedTheme : String = "Dark"
    @State var selectedLanguage : String = "en"
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
    @ObservedObject var settingVM = SettingViewModel()
    @State private var isSheetPresented = false
    var languages = ["English, Vietnamese"]
    @State private var isShowingSignOutAlert = false
    @State private var isSignOut = false
    
    var body: some View {
        NavigationStack{
            GeometryReader{ proxy in
                VStack {
                    VStack (alignment: .leading, spacing: 0) {
                        // Title and search field
                        Text("Settings")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 8)
                            .padding(.top)
                        
                        Button(action: {isSheetPresented.toggle()}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: proxy.size.width/40)
                                    .fill(!settingVM.isDarkMode ? .gray.opacity(0.1) : .gray.opacity(0.4))

                                    .frame(height: proxy.size.height/8)
                                
                                HStack {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: proxy.size.width/10)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Quoc Doan")
                                            .font(.title3)
                                            .bold()
                                        
                                        Text("@huuquoc7603")
                                            .opacity(0.8)
                                            .accentColor(.white)
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
                            
                            HStack {
                                Image(systemName: "globe.asia.australia.fill")
                                
                                Text("Language")
                                
                                Spacer()
                                
                                Picker("", selection: $selectedLanguage) {
                                    Text("English").tag("en")
                                    Text("Vietnamese").tag("vi")
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "moon")
                                
                                Text("Dark Mode")
                                
                                Spacer()
                                
                                Toggle("", isOn: $settingVM.isDarkMode)
                                    .padding(.bottom)
                            }
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
                            
                            HStack {
                                Button(action: {}) {
                                    Image(systemName: "bell")
                                    
                                    Text("Notifications")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.right.square")
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
                        
                        VStack(alignment: .leading) {
                            Text("Social")
                                .bold()
                                .padding(.bottom)
                            
                            HStack {
                                Button(action: {}) {
                                    Image(systemName: "person.fill.xmark")
                                    
                                    Text("Blocked")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.right.square")
                                        .font(Font.body)
                                        
                                }
                            }
                            
                            Divider()

                            HStack {
                                Button(action: {}) {
                                    Image(systemName: "rectangle.portrait.slash")

                                    Text("Hide story from")

                                    Spacer()

                                    Image(systemName: "arrow.right.square")
                                        .padding(.vertical)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        .background(RoundedRectangle(cornerRadius: proxy.size.width/40)
                            .fill(!settingVM.isDarkMode ? .gray.opacity(0.1) : .gray.opacity(0.4))
                        )
                        
                        Spacer()
                    }
                    
                    Button(action: {isShowingSignOutAlert.toggle()}) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .bold()
                            .font(.title3)
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
                .padding(.horizontal)
                .sheet(isPresented: $isSheetPresented) {
                    NavigationView {
                        SettingSheet(isSheetPresented: $isSheetPresented, settingVM: settingVM)
                    }
                }
                .foregroundColor(settingVM.isDarkMode ? .white : .black)
                .background(!settingVM.isDarkMode ? .white : .black)
            }
        }
    }
    
    @ViewBuilder
    func CustomTextFieldPass(icon: String,title: String, hint: String,value: Binding<String>,showPassword: Binding<Bool>) -> some View{
        // the custom textfied design
        VStack(alignment: .leading,spacing: 12){
            HStack{
                Label{
                    Text(isChange ? title : "Change " + title)
                        .font(.custom("Junegull-Regular", size: 14))
                } icon: {
                    Image(systemName: icon)
                }
                .foregroundColor(Color.black.opacity(0.8))
                Spacer()
                HStack{
                    VStack{
                        if (title.contains("Password")){
                            HStack{
                                Image(systemName: "pencil.line")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onTapGesture {
                                        isChange = false
                                        withAnimation{
                                            isCancel = true
                                        }
                                        print(isChange)
                                    }
                            }
                        }
                    }
                    .frame(width: 20)
                    
                    if (isCancel){
                        Text("Cancel")
                            .font(.custom("Junegull-Regular", size: 14))
                            .onTapGesture {
                                isChange = true
                                withAnimation{
                                    isCancel = false
                                }
                            }
                    }
                }
            }
            if (title.contains("Password") && !showPassword.wrappedValue){
                SecureField(hint,text:value)
                //                    .frame(width: 100)
                    .disabled(isChange)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
            else{
                TextField(hint, text: value)
                    .padding(.top,2)
                //                    .frame(width: 100)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
            Divider()
                .background(Color.white.opacity(0))
                .frame(width: 0)
            
        }
        // showing password
        .overlay(alignment: .trailing){
            Group{
                if (title.contains("Password")){
                    Button(action: {
                        showPassword.wrappedValue.toggle()
                    },label: {
                        Text(showPassword.wrappedValue ? "Hide" : "Show")
                            .font(.custom("Junegull-Regular", size: 13))
                            .foregroundColor(Color.black)
                    })
                    .offset(y:8)
                }
            }
            
        }
    }
    
    @ViewBuilder
    func CustomTextFieldUserName(icon: String,title: String, hint: String,value: Binding<String>,showPassword: Binding<Bool>) -> some View{
        // the custom textfied design
        VStack(alignment: .leading,spacing: 12){
            HStack{
                Label{
                    Text(isChangeUserName ? title : "Change " + title)
                        .font(.custom("Junegull-Regular", size: 14))
                } icon: {
                    Image(systemName: icon)
                }
                .foregroundColor(Color.black.opacity(0.8))
                Spacer()
                HStack{
                    VStack{
                        if (title.contains("User Name")){
                            HStack{
                                Image(systemName: "pencil.line")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onTapGesture {
                                        isChangeUserName = false
                                        withAnimation{
                                            isCancelUserName = true
                                        }
                                        print(isChange)
                                    }
                            }
                        }
                    }
                    .frame(width: 20)
                    
                    if (isCancelUserName){
                        Text("Cancel")
                            .font(.custom("Junegull-Regular", size: 14))
                            .onTapGesture {
                                isChangeUserName = true
                                withAnimation{
                                    isCancelUserName = false
                                }
                            }
                    }
                }
            }
            
            TextField(hint, text: value)
                .padding(.top,2)
            //                    .frame(width: 100)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .disabled(isChangeUserName)
            Divider()
                .background(Color.white.opacity(0))
                .frame(width: 0)
            
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
