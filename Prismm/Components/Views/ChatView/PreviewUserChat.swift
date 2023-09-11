//
//  PreviewUserChat.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 09/09/2023.
//

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
