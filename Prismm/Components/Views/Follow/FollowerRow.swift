//
//  RowView.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 09/09/2023.
//

import SwiftUI

struct FollowerRow: View {
    
    @ObservedObject var fvm: FollowViewModel
    
    var body: some View {
        HStack{
            Image("testAvt")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width/(UIDevice.current.userInterfaceIdiom == .phone ? 6 : 10))
                .clipShape(Circle())
            
            VStack(alignment: .leading){
                Text("UserName")
                    .font(.system(size: CGFloat(fvm.rowUserNameFontSize)))
                Text("bio")
                    .font(.system(size: CGFloat(fvm.rowBioFontSize)))
                    .opacity(0.4)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Remove")
                    .font(.system(size: CGFloat(fvm.rowButtonFontSize)))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width/4,height: UIScreen.main.bounds.height/(UIDevice.current.userInterfaceIdiom == .phone ? 25 : 30))
                    .background{
                        Color.black
                            .opacity(0.2)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }

        }
        .frame(minWidth: 0,maxWidth: .infinity)
        
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        FollowerRow(fvm: FollowViewModel())
        
        FollowerRow(fvm: FollowViewModel()).previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
