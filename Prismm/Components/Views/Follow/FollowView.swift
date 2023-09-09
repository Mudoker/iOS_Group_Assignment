//
//  FollowView.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 09/09/2023.
//

import SwiftUI

struct FollowView: View {
    @ObservedObject var fvm = FollowViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            
            //Navigation and Username
            HStack{
                
            }
            
            HStack{
                Button {
                    fvm.trueIsShowing()
                } label: {
                    Text(LocalizedStringKey("0 Followers"))
                        .opacity(fvm.isShowing == true ? 1 : 0.5)
                    
                }
                .frame(width: UIScreen.main.bounds.width/2)
                
                Button {
                    fvm.falseIsShowing()
                } label: {
                    Text(LocalizedStringKey("0 Following"))
                        .opacity(fvm.isShowing == true ? 0.5 : 1)
                    
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
                    .offset(x: fvm.isShowing ?  -(UIScreen.main.bounds.width/4) : (UIScreen.main.bounds.width/4))
            } //divider
            
            List {
                ForEach(fvm.followerList.indices) { _ in
                    FollowerRow()
                        
                       
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(SwiftUI.Visibility.hidden, edges: .bottom)
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .background{
                Color.clear
            }
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
