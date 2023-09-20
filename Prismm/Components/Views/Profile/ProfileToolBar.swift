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
    @EnvironmentObject var dataControllerVM: DataControllerViewModel
    
    @ObservedObject var authVM :AuthenticationViewModel
    @ObservedObject var settingVM: SettingViewModel
    
    @Binding var isSetting: Bool
    var body: some View {

        HStack{
            Text(dataControllerVM.currentUser?.username ?? "Failed to get data")
                .fontWeight(.bold)
                .font(.system(size: 20))    //should be responsive
            Spacer()
            
            
            Button {
                isSetting = true
            } label: {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.black)
                    .font(.system(size: 20))    //should be responsive
            }
        }

    }
}

//struct ProfileToolBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileToolBar()
//    }
//}
