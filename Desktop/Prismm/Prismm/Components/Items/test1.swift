//
//  test1.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import Foundation

import Foundation
import SwiftUI

struct test1: View {
    @State var isUserActive : Bool = true
    @State var selectedTheme : String = "Dark"
    @State var selectedLanguage : String = "vn"
    @State private var isRePassword = ""
    @State private var password : Bool = false
    @State private var rePassword : Bool = false
    @AppStorage("password") private var isPassword = ""
    var body: some View {
        VStack{
            CustomTextField(icon: "lock.fill" , title: "Password", hint: "12345", value: $isPassword, showPassword: $password)
                .padding(.top,10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    @ViewBuilder
    func CustomTextField(icon: String,title: String, hint: String,value: Binding<String>,showPassword: Binding<Bool>) -> some View{
        // the custom textfied design
        VStack(alignment: .leading,spacing: 12){
            Label{
                Text(title)
                    .font(.custom("Junegull-Regular", size: 14))
            } icon: {
                Image(systemName: icon)
            }
            .foregroundColor(Color.black.opacity(0.8))
            if (title.contains("Password") && !showPassword.wrappedValue){
                SecureField(hint,text:value)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
            else{
                TextField(hint, text: value)
                    .padding(.top,2)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
            
            Divider()
                .background(Color.black.opacity(0.4))
            
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
}

struct test1_Previews: PreviewProvider {
    static var previews: some View {
       test1()
    }
}
