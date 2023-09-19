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

  Created  date: 10/09/2023
  Last modified: 10/09/2023
  Acknowledgement: None
*/
import Foundation
import SwiftUI
struct AboutUs: View {
    var body: some View {
        NavigationStack{
            GeometryReader{ geometry in
                VStack{
                    ScrollView(.vertical){
                        LazyVStack{
                            Text("Who we are")
                                .font(Font.custom("Junegull-Regular", size: 45))
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment:.leading)
//                                .frame(height: getRect().height / 5.5)
                                .padding(.horizontal,20)
                            PersonalAboutUs()
                                .padding(.bottom,10)
                            PersonalAboutUs()
                                .padding(.bottom,10)
                            PersonalAboutUs()
                                .padding(.bottom,10)
                            PersonalAboutUs()
                                .padding(.bottom,10)
                        }
                        .padding(.top,20)
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 25){
                       
                        HStack(spacing: 10){
                            Text("tranvuquanganh87")
                            VStack{
                                Image(systemName: "chevron.down")
                                    .scaleEffect(0.6)
                            }
                            .frame(width: 5, height: 5)
                        }
                    }
                }
            }
        }
    }
}

extension View{
    func getRect() ->  CGRect{
        UIScreen.main.bounds
    }
}

struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
        AboutUs()
        
    }
}
