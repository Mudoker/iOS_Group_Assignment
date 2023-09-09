//
//  ProfileView.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 08/09/2023.
//

import SwiftUI

struct ProfileView: View {
    
    
    @State var haveHighlight = false
    @State var isSample = true
    @State var showingPost = 1
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading){
    
                ProfileToolBar()
                    
                
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
                            HStack(spacing: 15){ //should be responsive
                                VStack{
                                    Text(LocalizedStringKey("0"))
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Posts"))
                                    
                                }
                                
                                VStack{
                                    Text(LocalizedStringKey("0"))
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Followers"))
                                    
                                }
                                
                                VStack{
                                    Text(LocalizedStringKey("0"))
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Following"))
                                    
                                }
                            }
                            //edit button and share button
                            HStack{
                                Button {
                                    
                                } label: {

                                    Text(LocalizedStringKey("Edit Profile"))
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .frame(width: reader.size.width / 3.5,height: reader.size.height/20)
                                        .background{
                                            Color.gray
                                                .opacity(0.3)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                }

                                Button {
                                    
                                } label: {
                                    Text(LocalizedStringKey("Facebook Link"))
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .frame(width: reader.size.width / 3.5,height: reader.size.height/20)
                                        .background{
                                            Color.gray
                                                .opacity(0.3)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                }
                                

                            }
                        }
                    }
                    
                    HStack{
                        Text(LocalizedStringKey("FullName"))
                            .fontWeight(.bold)
                    }
                    HStack{
                        Text(LocalizedStringKey("Quote"))
                    }
                }

                
                
                
                //Highlight stories
//                if haveHighlight {
//
//                }else{
//                    VStack(alignment: .leading){
//                        HStack{
//
//                            Text(LocalizedStringKey("Story highlights"))
//                                .fontWeight(.bold)
//
//                            Spacer()
//
//                            Button {
//
//                                isSample.toggle()
//
//
//                            } label: {
//                                Image(systemName: isSample ? "chevron.up" : "chevron.down")
//                                    .foregroundColor(.black)
//                            }
//
//                        }
//
//                        //Stories sample
//                        if isSample {
//
//                            Text(LocalizedStringKey("Keep your favourite stories on your profile"))
//
//                            VStack{
//
//                                ZStack{
//                                    Image(systemName: "plus")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 40)
//                                }
//                                .frame(width: reader.size.width/5,height: reader.size.width/5)
//                                .clipShape(Circle())
//                                .overlay(Circle().stroke(Color.black).shadow(radius: 5))
//
//                                Text(LocalizedStringKey("New"))
//                            }
//
//                        }else{
//                            Divider()
//                                .frame(height: 2)
//                        }
//
//
//                    }
//                    .padding(.top,20)
//
//
//                }
                
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
                                .frame(height: 30) //not responsive
                                .foregroundColor(showingPost == 1 ? .black : .gray)
                            
                            Divider()
                                .overlay(showingPost == 1 ? .black : .gray)
                            
                            
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
                                .frame(width: 25,height: 30)    //not responsive
                                .foregroundColor(showingPost == 2 ? .black : .gray)

                            Divider()
                                .overlay(showingPost == 2 ? .black : .gray)
                        }.frame(width: (reader.size.width-40)/2)
                    }

                }
                .padding(.top)
                
            }
            .padding(.horizontal,20)
            .frame(minWidth: 0,maxWidth: .infinity)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
