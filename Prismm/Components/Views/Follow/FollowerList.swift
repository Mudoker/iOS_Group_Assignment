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

struct FollowerList: View {
    @ObservedObject var fvm: FollowViewModel
    
    var body: some View {
        ScrollView{
            TextField("", text: $fvm.searchText, prompt: Text("Search").font(.system(size: CGFloat(fvm.searchTextFontSize))).foregroundColor(fvm.isDarkMode ? .white : .black)).opacity(0.3)
                .frame(height: UIScreen.main.bounds.height/25)
                .background{
                    fvm.isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.1)
                        
                }
                .clipShape(RoundedRectangle(cornerRadius:8))
                .padding(.bottom, 20)
                
            
            ForEach(fvm.followerList.indices, id:\.self) { _ in
                FollowerRow(fvm: fvm)
                   
            }
        }
        .padding(.horizontal,15)
    }
}

struct FollowerList_Previews: PreviewProvider {
    static var previews: some View {
        FollowerList(fvm: FollowViewModel())
        
    }
}
