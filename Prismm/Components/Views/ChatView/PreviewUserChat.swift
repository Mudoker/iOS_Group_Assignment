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

import Foundation
import SwiftUI

struct PreviewUserChat: View {
    var body: some View {
            HStack{
                Image("sample_avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width : 65, height : 65)
                    .mask(Circle())
                VStack(alignment: .leading){
                    Text("Di Show thoai!!!!")
                        .font(.title3)
                        .fontWeight(.bold)
                    HStack{
                        VStack{
                            Text("Di thoi cac ban oi dan gio roi!!!!!!!!!")
                        }
                        .frame(width: 243, height : 10)
                        
                        Text("5h")
                    }
                }
            }
            .padding(8)
//            .background(Color.gray.opacity(0.2))
//            .cornerRadius(20)
    }
}

struct PreviewUserChat_Previews: PreviewProvider {
    static var previews: some View {
       PreviewUserChat()
    }
}
