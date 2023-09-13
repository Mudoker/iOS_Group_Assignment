//
//  ProfileToolBar.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 08/09/2023.
//

import SwiftUI

struct ProfileToolBar: View {
    var body: some View {

        HStack{
            Text(LocalizedStringKey("UserName"))
                .fontWeight(.bold)
                .font(.system(size: 20))    //should be responsive
            Spacer()
            
            
            HStack(spacing: 20){ // should be responsive
                Button {
                    
                } label: {
                    Image(systemName: "plus.app")
                        .foregroundColor(.black)
                        .font(.system(size: 20))    //should be responsive
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.black)
                        .font(.system(size: 20))    //should be responsive
                }
            }
        }
    }
}

struct ProfileToolBar_Previews: PreviewProvider {
    static var previews: some View {
        ProfileToolBar()
    }
}
