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
  Last modified: 10/09/2023
  Acknowledgement: None
*/

import SwiftUI

struct ProfileView: View {
    @State var isSample = true
    
    @StateObject var profileVM: ProfileViewModel

    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading){
                ProfileToolBar()
                
                //Profile info block
                VStack(alignment: .leading){
                    HStack{
                        Image("testAvt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: proxy.size.width/4)
                            .clipShape(Circle())
                        Spacer()
                        
                        VStack{
                            HStack(spacing: 15){ //should be responsive
                                VStack{
                                    Text("0")
                                        .fontWeight(.bold)
                                    Text("Posts")
                                    
                                }
                                
                                VStack{
                                    Text("0")
                                        .fontWeight(.bold)
                                    Text("Followers")
                                    
                                }
                                
                                VStack{
                                    Text("0")
                                        .fontWeight(.bold)
                                    Text("Following")
                                    
                                }
                            }
                            //edit button and share button
                            HStack{
                                Button {
                                    
                                } label: {

                                    Text("Edit Profile")
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .frame(width: proxy.size.width / 3.5,height: proxy.size.height/20)
                                        .background{
                                            Color.gray
                                                .opacity(0.3)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                }

                                Button {
                                    
                                } label: {
                                    Text("Facebook Link")
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .frame(width: proxy.size.width / 3.5,height: proxy.size.height/20)
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
                        Text("FullName")
                            .fontWeight(.bold)
                    }
                    HStack{
                        Text("Quote")
                    }
                }
                
                //Highlight stories
                if profileVM.hasStoryHightlight {

                } else {
                    VStack(alignment: .leading){
                        HStack{

                            Text("Story highlights")
                                .fontWeight(.bold)

                            Spacer()

                            Button {

                                isSample.toggle()


                            } label: {
                                Image(systemName: isSample ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.black)
                            }

                        }

                        //Stories sample
                        if isSample {

                            Text("Keep your favourite stories on your profile")

                            VStack{

                                ZStack{
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40)
                                }
                                .frame(width: proxy.size.width/5,height: proxy.size.width/5)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.black).shadow(radius: 5))

                                Text("New")
                            }

                        } else {
                            Divider()
                                .frame(height: 2)
                        }


                    }
                    .padding(.top,20)


                }
                
                //tab changing
                HStack{
                    
                    Button {
                        withAnimation {
                            profileVM.isShowAllUserPost = true
                        }
                    } label: {
                        VStack{
                            Image(systemName: "squareshape.split.3x3")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30) //not responsive
                                .foregroundColor(profileVM.isShowAllUserPost ? .black : .gray)
                            
                            Divider()
                                .overlay(profileVM.isShowAllUserPost ? .black : .gray)
                            
                            
                        }
                        .frame(width: (proxy.size.width-40)/2)
                        
                    }
                    
                    Button {
                        withAnimation {
                            profileVM.isShowAllUserPost = false
                        }
                    } label: {
                        VStack{
                            Image(systemName: "bookmark")
                                .resizable()
                                .frame(width: 25,height: 30)    //not responsive
                                .foregroundColor(!profileVM.isShowAllUserPost ? .black : .gray)

                            Divider()
                                .overlay(!profileVM.isShowAllUserPost ? .black : .gray)
                        }.frame(width: (proxy.size.width-40)/2)
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
        ProfileView(profileVM: ProfileViewModel())
    }
}
