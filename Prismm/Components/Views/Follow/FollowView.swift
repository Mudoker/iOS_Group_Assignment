/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Apple Men
  Doan Huu Quoc (s3927776)
  Tran Vu Quang Anh (s3916566)
  Nguyen Dinh Viet (s3927291)
  Nguyen The Bao Ngoc (s3924436)

  Created  date: 09/09/2023
  Last modified: 09/09/2023
  Acknowledgement: None
*/

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
                
                Spacer()
            }
            .foregroundColor(fvm.isDarkMode ? .white : .black)
            .padding(.bottom,10)
            .padding(.leading, 20 )
            
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
            .foregroundColor(fvm.isDarkMode ? .white : .black)
            
            ZStack{
                Divider()
                    .overlay {
                        fvm.isDarkMode ? Color.white : Color.black
                    }
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width/2,height: 1)
                    .overlay {
                        fvm.isDarkMode ? Color.white : Color.black
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
        .background{
            fvm.isDarkMode ? Color.black : Color.white
        }
    }
}

struct FollowView_Previews: PreviewProvider {
    static var previews: some View {
        FollowView()
        
        FollowView().previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
