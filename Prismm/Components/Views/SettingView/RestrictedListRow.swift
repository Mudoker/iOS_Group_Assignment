//
//  BlockListRow.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 23/09/2023.
//

import SwiftUI
import Kingfisher

struct RestrictedListRow: View {
    let user: User
    @ObservedObject var restrictVM : RestrictViewModel
    
    var body: some View {
        HStack{

            if user.profileImageURL != "" {
                KFImage(URL(string: user.profileImageURL ?? ""))
                    .resizable()
                    .frame(width: 50 , height: 50)
                    .clipShape(Circle())
                    .background(Circle().foregroundColor(Color.gray))
            

            } else {
                // Handle the case where the media URL is invalid or empty.
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                
            }
            
            Text(user.username)
            
            Spacer()
            Button {
                Task{
                    var removeIndex = 0
                    try await APIService.unRestrictOtherUser(forUserID: user.id)
                    
                    
                    for index in restrictVM.userRestricList.indices{
                        if restrictVM.userRestricList[index].id == user.id{
                            removeIndex = index
                        }
                    }
                    
                    withAnimation {
                        restrictVM.userRestricList.remove(at: removeIndex)
                    }
                }
            } label: {
                Text("Unrestricted")
                    .foregroundColor(.red)
                    .frame(width: 130, height: 30)
                    .background{
                        Color.gray
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
            }

        }
    }
    
    
    
}

//struct RestrictedListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        RestrictedListRow(user: User(id: "1", account: "ngoc"))
//    }
//}

