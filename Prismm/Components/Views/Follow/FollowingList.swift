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

struct FollowingList: View {
    //Control state
    @ObservedObject var fvm: FollowViewModel
    
    var body: some View {
        ScrollView{
            // search field
            TextField("", text: $fvm.searchText, prompt: Text("Search")
                .font(.system(size: CGFloat(fvm.searchTextFontSize)))
                .foregroundColor(fvm.isDarkMode ? .white : .black)
            )
            .opacity(0.3)
            .padding()
            .frame(height: UIScreen.main.bounds.height / 23)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(!fvm.isDarkMode ? Color.black.opacity(0.1) : Color.white.opacity(0.1))
            )
            .padding(.vertical)
            
            // content
            ForEach(fvm.followingList) { user in
                FollowingRow(fvm: fvm, user: user)
                
            }
        }
        .padding(.horizontal,15)
    }
}

struct FollowingList_Previews: PreviewProvider {
    static var previews: some View {
        FollowingList(fvm: FollowViewModel())
    }
}
