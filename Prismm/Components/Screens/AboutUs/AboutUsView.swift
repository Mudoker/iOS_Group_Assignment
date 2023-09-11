//
//  AboutUsView.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 10/09/2023.
//

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
                                .font(.custom("Junegull-Regular", size: 45))
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
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
        
    }
}
