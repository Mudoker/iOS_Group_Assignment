//
//  FollowingList.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 09/09/2023.
//

import SwiftUI

struct FollowingList: View {
    @ObservedObject var fvm: FollowViewModel
    
    var body: some View {
        ScrollView{
            TextField("", text: $fvm.searchText, prompt: Text("Search").font(.system(size: CGFloat(fvm.searchTextFontSize))))
                .frame(height: UIScreen.main.bounds.height/25)
                .background{
                    Color.black
                        .opacity(0.1)
                }
                .clipShape(RoundedRectangle(cornerRadius:8))
                .padding(.bottom, 20)
                
            
            ForEach(fvm.followerList.indices) { _ in
                FollowingRow(fvm: fvm)
                   
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
