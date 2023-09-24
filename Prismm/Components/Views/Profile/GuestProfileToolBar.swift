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

struct GuestProfileToolBar: View {
    // Control state
    @Binding var currentUser:User
    @Binding var userSetting:UserSetting
    
    var user: User
    
    @ObservedObject var profileVM: GuestProfileViewModel

    var body: some View {
        HStack{
            Text(user.username)
                .fontWeight(.bold)
                .font(.system(size: profileVM.toolBarUserNameSize))
            
            // Push view
            Spacer()
            
            // Setting
            Button {
                profileVM.isPopover = true
            } label: {
                Image(systemName: "ellipsis")
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
