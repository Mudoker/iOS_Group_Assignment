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
  Last modified: 10/09/2023
  Acknowledgement: None
*/

import SwiftUI

struct ProfileToolBar: View {
    @Binding var currentUser:User
    @Binding var userSetting:UserSetting
    
    @ObservedObject var profileVM: ProfileViewModel

    var body: some View {

        HStack{
            Text(currentUser.username)
                .fontWeight(.bold)
                .font(.system(size: profileVM.toolBarUserNameSize)) 
            Spacer()
            
            
            Button {
                profileVM.isSetting = true
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: profileVM.toolBarSettingButtonSize))
            }
        }
        .foregroundColor(userSetting.darkModeEnabled ? .white : .black)

    }
}



//struct ProfileToolBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileToolBar(profileVM: ProfileViewModel())
//    }
//}
