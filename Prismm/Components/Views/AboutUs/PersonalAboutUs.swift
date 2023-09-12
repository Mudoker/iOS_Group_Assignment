//
//  PersonalAboutUs.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 10/09/2023.
//

import Foundation
//
//  AboutUsView.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 10/09/2023.
//

import Foundation
import SwiftUI
struct PersonalAboutUs: View {
    var body: some View {
//        GeometryReader{ geometry in
            VStack{
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.white).opacity(0.4), lineWidth: 3)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.pink.opacity(0.2)))
                
                // responsive
                    .frame(width: 363, height: 400)
                    .padding(.horizontal,15)
                    .overlay{
                        VStack(spacing: 10){
                            HStack{
                                Image("sample_avatar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width : 50, height : 50)
                                    .mask(Circle())
                                
                                Image("sample_avatar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width : 150, height : 150)
                                    .mask(Circle())
                                
                                Image("sample_avatar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width : 50, height : 50)
                                    .mask(Circle())
                            }
                            HStack{
                                Text("Name")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 1, height: 20)
                                Text("Role")
                                    .opacity(0.4)
                            }
                            VStack(alignment: .center){
                                Text("abcbcbcbcbcbcbcbcbcbcbcbcbqaaaaaa")
                                
                            }
                            .frame(width: 300)
                            
                            HStack{
                                Spacer()
                                Circle()
                                    .stroke(Color(.white).opacity(0.4), lineWidth: 2)
                                    .frame(width: 50, height: 50)
                                    .shadow(color: Color("R-shadow"), radius: 2, x: 2, y: 5)
                                    .overlay{
                                        VStack{
                                            Image("github")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .frame(width: 25, height: 25)
                                    }
                                Spacer()
                                Circle()
                                    .stroke(Color(.white).opacity(0.4), lineWidth: 2)
                                    .frame(width: 50, height: 50)
                                    .shadow(color: Color("R-shadow"), radius: 2, x: 2, y: 5)
                                    .overlay{
                                        VStack{
                                            Image("fb")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .frame(width: 25, height: 25)
                                    }
                                Spacer()
                                Circle()
                                    .stroke(Color(.white).opacity(0.4), lineWidth: 2)
                                    .frame(width: 50, height: 50)
                                    .shadow(color: Color("R-shadow"), radius: 2, x: 2, y: 5)
                                    .overlay{
                                        VStack{
                                            Image("mail")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .frame(width: 25, height: 25)
                                    }
                                Spacer()
                                Circle()
                                    .stroke(Color(.white).opacity(0.4), lineWidth: 2)
                                    .frame(width: 50, height: 50)
                                    .shadow(color: Color("R-shadow"), radius: 2, x: 2, y: 5)
                                    .overlay{
                                        VStack{
                                            Image("linkedin")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .frame(width: 25, height: 25)
                                    }
                                Spacer()
                            }
                        }
                    }
            }
//        }
    }
}

struct PersonalAboutUs_Previews: PreviewProvider {
    static var previews: some View {
        PersonalAboutUs()
    }
}
