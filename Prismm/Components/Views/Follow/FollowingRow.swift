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
 Last modified: 09/09/2023
 Acknowledgement: None
 */

import SwiftUI

struct FollowingRow: View {
    //Control state
    @ObservedObject var fvm: FollowViewModel
    
    var user:User
    
    var body: some View {
        HStack{
            //  User information
            Image("testAvt")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width/(UIDevice.current.userInterfaceIdiom == .phone ? 6 : 10))
                .clipShape(Circle())
            
            VStack(alignment: .leading){
                Text(user.username)
                    .font(.system(size: CGFloat(fvm.rowUserNameFontSize)))
                
                Text(user.bio ?? "")
                    .font(.system(size: CGFloat(fvm.rowBioFontSize)))
                    .opacity(0.4)
            }
            .foregroundColor(fvm.isDarkMode ? .white : .black)
            
            Spacer()
            
            //Buttons
            HStack(spacing: UIDevice().userInterfaceIdiom == .phone ? 10 : 15){
                Button {
                    //Unfollow
                
                    Task{
                        var removeIndex = 0
                        try await APIService.unfollowOtherUser(forUserID: user.id)
                        
                        
                        for index in fvm.followingList.indices{
                            if fvm.followingList[index].id == user.id{
                                removeIndex = index
                            }
                        }
                        
                        withAnimation {
                            fvm.followingList.remove(at: removeIndex)
                        }
                    }
                } label: {
                    Text(  "Following" )//: "Follow")
                        .font(.system(size: CGFloat(fvm.rowButtonFontSize)))
                        .fontWeight(.bold)
                        .foregroundColor(fvm.colorTheme)
                        .frame(width: UIScreen.main.bounds.width/4,height: UIScreen.main.bounds.height/(UIDevice.current.userInterfaceIdiom == .phone ? 25 : 30))
                        .background{
                            fvm.isDarkMode ? Color.white.opacity(0.2) : Color.black.opacity(0.2)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIDevice().userInterfaceIdiom == .phone ? 20 : 30)
                }
            }
            .foregroundColor(fvm.isDarkMode ? .white : .black)
        }
        .frame(minWidth: 0,maxWidth: .infinity)
    }
}

//struct FollowingRow_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowingRow(fvm: FollowViewModel())
//    }
//}
