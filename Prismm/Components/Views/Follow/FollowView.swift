//
//  FollowView.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 09/09/2023.
//

import SwiftUI

struct FollowView: View {
    @StateObject var fvm = FollowViewModel()
    
    
    var body: some View {
        VStack(alignment: .center) {
            
            //Navigation and Username
            HStack{
                Text("Username")
                    .font(.system(size: CGFloat(fvm.userNameFontSize)))
                    .fontWeight(.bold)
            }
            .padding(.bottom,10)
            
            HStack{
                Button {
                    fvm.trueIsShowing()
                    
                    
                } label: {
                    Text(LocalizedStringKey("0 Followers"))
                        .font(.system(size: CGFloat(fvm.tabNameFontSize)))
                        .opacity(fvm.tabSelection == 1 ? 1 : 0.5)
                    
                }
                .frame(width: UIScreen.main.bounds.width/2)
                
                Button {
                    fvm.falseIsShowing()
                    
                } label: {
                    Text(LocalizedStringKey("0 Following"))
                        .font(.system(size: CGFloat(fvm.tabNameFontSize)))
                        .opacity(fvm.tabSelection == 2 ? 1 : 0.5)
                    
                }
                .frame(width: UIScreen.main.bounds.width/2)
                
            }
            .foregroundColor(.black)
            
            ZStack{
                Divider()
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width/2,height: 1)
                    .overlay {
                        Color.black
                    }
                    .offset(x: fvm.indicatorOffset)
            } //divider
            
            
            TabView(selection: $fvm.tabSelection) {
                FollowerList(fvm: fvm)
                    .tag(1)
                
                FollowingList(fvm: fvm)
                    .tag(2)
            }
            .animation(.easeInOut, value: fvm.tabSelection)
            .tabViewStyle(PageTabViewStyle())
            
            

            Spacer()
        }
    }
}

struct FollowView_Previews: PreviewProvider {
    static var previews: some View {
        FollowView()
        
        FollowView().previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
