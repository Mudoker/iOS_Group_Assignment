//
//  FollowerList.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 09/09/2023.
//

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
                
            
            ForEach(fvm.followerList.indices) { _ in
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
