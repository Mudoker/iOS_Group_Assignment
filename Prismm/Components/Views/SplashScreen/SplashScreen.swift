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

  Created  date: 08/09/2023
  Last modified: 13/09/2023
  Acknowledgement: None
*/

import Foundation
import SwiftUI
import Firebase
struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var isText = false
    @State private var isDarMode = false
    @StateObject var manager = AppManager(isSignIn:  Auth.auth().currentUser != nil ? true : false )
    var body: some View {
        NavigationStack{
            GeometryReader{ geometry in
                if isActive {
                    if !manager.isSignIn {
                        Login()
                           
                            
                    } else {
                        TabBar()
                            
                    }
                }
                else{
                    ZStack{
                        Color(.white)
                            .ignoresSafeArea()
                        ZStack{
                            HStack(spacing: 0){
                                VStack(alignment: .trailing){
                                    Image("logoNoText")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                    
                                }
                                .frame(width: 200, height: 200,alignment: .trailing)
                                .scaleEffect(size)
                                .opacity(opacity)
                                .onAppear{
                                    withAnimation(.easeIn(duration: 1.2)){
                                        self.size = 0.9
                                        self.opacity = 1.0
                                    }
                                }
//                                .background(.yellow)
                                .position(x: isText ? geometry.size.width / 2 - 90 : geometry.size.width / 2, y: geometry.size.height / 2)
                                
                                VStack{
                                    Text("Prism")
                                        .font(.custom("Junegull-Regular", size: geometry.size.width >=  834 ? 30 : 40 ))
                                    Text("Through your lens")
                                        .font(.custom("Junegull-Regular", size: geometry.size.width >=  834 ? 30 : 15 ))
                                }
//                                .background(.yellow)
                                .position(x : geometry.size.width / 2 - 160, y : geometry.size.height / 2)
                                .opacity(isText ? 1 : 0)
                            }
                        }
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                                withAnimation(){
                                    self.isText = true
                                    self.isActive = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
            .previewDevice("iPhone 14 Pro")
        SplashScreen()
            .previewDevice("iPhone 14 Pro Max")
        SplashScreen()
            .previewDevice("iPhone 14")
        SplashScreen()
            .previewDevice("iPad Pro (11-inch) (4th generation)")
        SplashScreen()
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}
