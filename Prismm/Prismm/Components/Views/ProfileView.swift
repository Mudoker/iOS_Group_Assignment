//
//  ProfileView.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 08/09/2023.
//

import SwiftUI

struct ProfileView: View {
    
    //@State
    @State var isDarkMode = false
    
    @State var haveHighlight = false
    @State var isSample = true
    @State var showingPost = 1
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center){
    
                
               
                ProfileToolBar(isDarkMode: $isDarkMode)
                    .padding(.horizontal, 20)
                
                //Profile info block
                VStack(alignment: .leading){
                    HStack{
                        Image("testAvt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: reader.size.width/4)
                            .clipShape(Circle())
                        Spacer()
                        VStack{
                            HStack(spacing: reader.size.width/17){
                                VStack{
                                    Text(LocalizedStringKey("0"))
                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 24 : 30))
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Posts"))
                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 18 : 26))
                                        .opacity(0.5)
                                    
                                }
                                
                                
                                VStack{
                                    Text(LocalizedStringKey("0"))
                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 24 : 30))
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Followers"))
                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 18 : 26))
                                        .opacity(0.5)
                                    
                                }
                                
                                
                                VStack{
                                    Text(LocalizedStringKey("0"))
                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 24 : 30))
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Following"))
                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 18 : 26))
                                        .opacity(0.5)
                                }
                            }
                            .foregroundColor(isDarkMode ? Color.white : Color.black)
                            
                            //edit button and share button
                            HStack{
                                Button {
                                    
                                } label: {

                                    Text(LocalizedStringKey("Edit Profile"))
                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 14 : 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                                        .frame(width: reader.size.width / 3.5,height: reader.size.height/20)
                                        .background{
                                            Color.gray
                                                .opacity(isDarkMode ? 0.3 :0.1)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }

                                Button {
                                    
                                } label: {
                                    Text(LocalizedStringKey("F"))
                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 14 : 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                                        .frame(width: reader.size.width / 3.5,height: reader.size.height/20)
                                        .background{
                                            Color.gray
                                                .opacity(isDarkMode ? 0.3 : 0.1)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                

                            }
                        }
                    }
                        .frame(minWidth: 0,maxWidth: .infinity)
                    HStack{
                        Text(LocalizedStringKey("FullName"))
                            .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 24 : 40))
                            .fontWeight(.bold)
                    }
                    HStack{
                        Text(LocalizedStringKey("Quote"))
                            .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 18 : 26))
                            .opacity(0.5)
                    }
                }
                .padding(.horizontal, 20)
                .foregroundColor(isDarkMode ? Color.white : Color.black)

                
                //tab changing
                HStack{
                    
                    Button {
                        withAnimation {
                            showingPost = 1
                        }
                    } label: {
                        VStack{
                            Image(systemName: "squareshape.split.3x3")
                                .resizable()
                                .scaledToFit()
                                .frame(height: UIDevice.current.userInterfaceIdiom == .phone ? 30 : 40) //not responsive
                                .foregroundColor(showingPost == 1 ? isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor : .gray)
                                
                            Divider()
                                .overlay(showingPost == 1 ? isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor : .gray)
                               
                            
                        }
                        .frame(width: (reader.size.width-40)/2)
                        
                    }
                    
                    Button {
                        withAnimation {
                            showingPost = 2
                        }
                    } label: {
                        VStack{
                            Image(systemName: "bookmark")
                                .resizable()
                                .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? 30 : 40,height: UIDevice.current.userInterfaceIdiom == .phone ? 30 : 40)
                                .foregroundColor(showingPost == 2 ? isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor : .gray)

                            Divider()
                                .overlay(showingPost == 2 ? isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor : .gray)
                        }.frame(width: (reader.size.width-40)/2)
                    }

                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.top)
                

                
                
                ScrollView(.vertical, showsIndicators: false) {
                    PostGridView()
                }
                
            }
            .frame(minWidth: 0,maxWidth: .infinity)
            
        }
        .background(isDarkMode ? Color.black : Color.white)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
        
        ProfileView().previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
