//
//  SettingSheet.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 11/09/2023.
//

import SwiftUI

struct SettingSheet: View {
    @Binding var isSheetPresented: Bool
    @ObservedObject var settingVM = SettingViewModel()
    var body: some View {
//        NavigationView {
        VStack (alignment: .center) {
                Text("Accont Manager")
                .bold()
                .padding(.horizontal)
                .font(.title)
            
                VStack {
                    NavigationLink(destination: EditProfileView(settingVM: settingVM)) {
                        HStack {
                            Image(systemName: "person.badge.plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            
                            Text("Personal Information")
                                .padding(.leading)
                            
                            Spacer()
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(!settingVM.isDarkMode ? .gray.opacity(0.1) : .gray.opacity(0.4))
                        )
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    NavigationLink(destination: EditSecurityField(settingVM: settingVM)) {
                        HStack {
                            Image(systemName: "lock.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                            
                            Text("Password & Security")
                                .padding(.leading)
                            
                            Spacer()
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(!settingVM.isDarkMode ? .gray.opacity(0.1) : .gray.opacity(0.4))
                        )
                    }
                    .padding()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(settingVM.isDarkMode ? .white : .black)
            .background(settingVM.isDarkMode ? .black : .white)
            .navigationBarItems(trailing: Button("Close") {
                isSheetPresented.toggle()
            })
//        }
        
    }
}
struct PersonalInformationView: View {
    var body: some View {
        // Content for Personal Information View
        Text("Personal Information View")
    }
}

struct PasswordSecurityView: View {
    var body: some View {
        // Content for Password & Security View
        Text("Password & Security View")
    }
}

struct EmailView: View {
    var body: some View {
        // Content for Email View
        Text("Email View")
    }
}

struct ConnectionsView: View {
    var body: some View {
        // Content for Connections View
        Text("Connections View")
    }
}

struct SettingSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingSheet(isSheetPresented: .constant(true))
    }
}
