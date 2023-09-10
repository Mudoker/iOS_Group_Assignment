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
    @State var selectedLanguage : String = "vn"
    @State private var isRePassword = ""
    @State private var password : Bool = false
    @State private var rePassword : Bool = false
    @State private var isChange = true
    @State private var isCancel = false
    @State private var isChangeUserName = true
    @State private var isCancelUserName = false
    //    @AppStorage("password") private var isPassword = ""
    @State private var isPassword = "12345"
    
    var body: some View {
        NavigationStack{
            GeometryReader{ geometry in
                ZStack{
                    //                    Color(.gray)
                    //                        .opacity(0.3)
                    //                        .edgesIgnoringSafeArea(.bottom)
                    
                    ScrollView{
                        LazyVStack(spacing : 10){
                            VStack{
                                CustomTextFieldUserName(icon: "person.fill" , title: "User Name", hint: "quanganh87", value: $name, showPassword: .constant(false))
                                    .padding(.top,10)
                                
                                CustomTextFieldPass(icon: "lock.fill" , title: "Password", hint: "12345", value: $isPassword, showPassword: $password)
                                    .padding(.top,10)
                                
                            }
                            .padding(.horizontal,10)
                            .background(.white)
                            
                            Rectangle()
                                .frame(height: 10)                                 .foregroundColor(Color.gray.opacity(0.06))
                            
                            VStack{
                                Text("Theme")
                                    .foregroundColor(.black)
                                    .font(.title)
                                    .padding(.top)
                                if selectedTheme == "system" {
                                    Text("Ensure system theme has been updated!")
                                        .foregroundColor(.black)
                                        .opacity(0.7)
                                        .font(.title)
                                        .italic()
                                }
                                
                                Picker("Theme", selection: $selectedTheme) {
                                    Text("Light")
                                        .tag("light")
                                    Text("Dark")
                                        .tag("dark")
                                    Text("System")
                                        .tag("system")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                
                                Text("Language")
                                    .font(.title)
                                    .padding(.top)
                                
                                Picker("Language", selection: $selectedLanguage) {
                                    Text("English").tag("en")
                                    Text("Vietnamese").tag("vi")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .padding(.horizontal,10)
                            .background(.white)
                            
                            Rectangle()
                                .frame(height: 10)                                 .foregroundColor(Color.gray.opacity(0.06))
                                .padding(.top,20)
                            
                            VStack{
                                HStack{
                                    VStack{
                                        Image(systemName: "info.bubble")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: 20)
                                    Text("About Us")
                                        .font(.title2)
                                    Spacer()
                                    NavigationLink(destination: AboutUs()){
                                        VStack{
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(.blue)
                                        }
                                        .frame(width : 7)
                                    }
                                    
                                }
                                .padding(.top,10)
                                HStack{
                                    VStack{
                                        Image(systemName: "questionmark.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: 20)
                                    Text("Help")
                                        .font(.title2)
                                    Spacer()
                                    VStack{
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.blue)
                                    }
                                    .frame(width: 7)
                                    
                                }
                                .padding(.top,10)
                                
                                HStack{
                                    VStack{
                                        Image(systemName: "x.square")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: 20)
                                    Text("Delete Account")
                                        .foregroundColor(.black)
                                        .font(.title2)
                                    Spacer()
                                    VStack{
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.blue)
                                        //                                            .fontWeight(.bold)
                                    }
                                    .frame(width: 7)
                                }
                                .padding(.bottom,10)
                            }
                            .padding(.horizontal,10)
                            .frame(width: geometry.size.width, height: 150)
                            .background(.white)
                            
                            VStack{
                                Button() {
                                    
                                } label:{
                                    Text("Let's begin")
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: geometry.size.width, minHeight: 55)
                                .background(Color.blue)
                                .tint(.white)
                                .clipShape(RoundedRectangle(cornerRadius:18))
                                .padding()
                                
                                NavigationLink(destination: test1()
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)) {
                                        ZStack {
                                            Text("Sign out")
                                                .foregroundColor(.red)
                                                .bold()
                                        }
                                    }
                                    .simultaneousGesture(
                                        TapGesture()
                                            .onEnded {
                                                
                                            }
                                    )
                            }
                        }
                        .toolbar{
                            ToolbarItem(placement: .navigationBarLeading) {
                                HStack(spacing: 25){
                                    Button{
                                        
                                    } label : {
                                        Image(systemName: "arrow.left")
                                    }
                                    HStack(spacing: 10){
                                        Text("tranvuquanganh87")
                                        VStack{
                                            Image(systemName: "chevron.down")
                                                .scaleEffect(0.6)
                                        }
                                        .frame(width: 5, height: 5)
                                    }
                                }
                            }
                        }
                    }
                }
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
