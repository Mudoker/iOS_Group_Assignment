//
//  ProfileToolBar.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 08/09/2023.
//

import SwiftUI

struct ProfileToolBar: View {
    @Binding var isDarkMode: Bool
    
    var body: some View {

        HStack{
            Text(LocalizedStringKey("UserName"))
                .fontWeight(.bold)
                .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 40))    //should be responsive
            Spacer()
            
            
            HStack(spacing: 20){ // should be responsive
                Button {
                    
                } label: {
                    Image(systemName: "plus.app")
                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 40))    //should be responsive
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 40))    //should be responsive
                }
            }
        }
        .foregroundColor(isDarkMode ? Color.white : Color.black)
    }
    
}

struct ProfileToolBar_Previews: PreviewProvider {
    static var previews: some View {
        ProfileToolBar(isDarkMode: .constant(true))
        
        ProfileToolBar(isDarkMode: .constant(true)).previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
