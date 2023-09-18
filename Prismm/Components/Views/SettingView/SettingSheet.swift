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
                            .fill(!settingVM.isDarkModeEnabled ? .gray.opacity(0.1) : .gray.opacity(0.4))
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
                            .fill(!settingVM.isDarkModeEnabled ? .gray.opacity(0.1) : .gray.opacity(0.4))
                        )
                    }
                    .padding()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(settingVM.isDarkModeEnabled ? .white : .black)
            .background(settingVM.isDarkModeEnabled ? .black : .white)
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
