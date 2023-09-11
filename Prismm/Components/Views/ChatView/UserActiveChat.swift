//
//  UserActiveChat.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 09/09/2023.
//


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
