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
    //Control state
    @Binding var isSheetPresented: Bool
    @Binding var currentUser:User
    @Binding var userSetting:UserSetting
    @ObservedObject var settingVM:SettingViewModel
    var body: some View {
        VStack (alignment: .center) {
            // Title
            Text("Accont Manager")
                .bold()
                .padding(.horizontal)
                .font(.title)
            
            // Content
            VStack {
                // Profile setting
                NavigationLink(destination: EditProfileView(currentUser: $currentUser, userSetting: $userSetting, settingVM: settingVM)) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                        
                        Text("Personal Information")
                            .padding(.leading)
                        
                        // Push view
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(!userSetting.darkModeEnabled ? .gray.opacity(0.1) : .gray.opacity(0.4))
                    )
                }
                .padding(.top)
                .padding(.horizontal)
                
                // Security setting
                NavigationLink(destination: EditSecurityField(currentUser: $currentUser, userSetting: $userSetting, settingVM: settingVM)) {
                    HStack {
                        Image(systemName: "lock.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                        
                        Text("Password & Security")
                            .padding(.leading)
                        
                        // Push view
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(!userSetting.darkModeEnabled ? .gray.opacity(0.1) : .gray.opacity(0.4))
                    )
                }
                .padding()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(userSetting.darkModeEnabled ? .white : .black)
        .background(userSetting.darkModeEnabled ? .black : .white)
        .navigationBarItems(trailing: Button("Close") {
            isSheetPresented.toggle()
        })
    }
}

//struct SettingSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingSheet(isSheetPresented: .constant(true))
//    }
//}
