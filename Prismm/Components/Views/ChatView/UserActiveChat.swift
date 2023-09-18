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

struct UserActiveChat: View {
    @State var isUserActive : Bool = true
    var body: some View {
        VStack{
            Image("sample_avatar")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width : 80, height : 80)
                .mask(Circle())
                .overlay{
                    VStack{
                        Image(systemName: "message.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .shadow(color: .gray, radius: 4, x: 2, y: 2)
                    }
                    .frame(width: 130,height : 130,alignment: .topTrailing)
                    
                    HStack(alignment: .center){
                       Circle()
                            .foregroundColor(isUserActive ? .green: .white)
                            .frame(width: 20, height: 20)
                    }
                    .frame(width: 80, height:75,alignment: .bottomTrailing)
                }
        }
        .onTapGesture {
            print("1")
        }
    }
}

struct UserActiveChat_Previews: PreviewProvider {
    static var previews: some View {
        UserActiveChat()
    }
}
