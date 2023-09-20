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
    
    @ObservedObject var authVM :AuthenticationViewModel
    @ObservedObject var settingVM:SettingViewModel
    @ObservedObject var profileVM: ProfileViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading){
                ProfileToolBar(authVM: authVM, settingVM: settingVM)
                
                //Profile info block
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        Image("testAvt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: profileVM.avatarSize, height: profileVM.avatarSize)
                            .clipShape(Circle())
                        Spacer()
                        
                        VStack{
                            HStack(spacing: 15){ //should be responsive
                                VStack{
                                    Text("\(authVM.currentUser?.posts.count ?? 111)")
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Posts"))
                                    
                                }
                                
                                VStack{
                                    Text("\(authVM.currentUser?.followers.count ?? 111)")
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Followers"))
                                    
                                }
                                
                                VStack{
                                    Text("\(authVM.currentUser?.following.count ?? 111)")
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
                                        .frame(width: proxy.size.width / 3.5,height: proxy.size.height/20)
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
                        Text(authVM.currentUser?.fullName ?? "Failed to get data")
                            .fontWeight(.bold)
                    }
                    HStack{
                        Text(authVM.currentUser?.bio ?? "Failed to get data")
                    }
                }
                
                //Highlight stories
                if profileVM.hasStoryHightlight {

                } else {
                    VStack(alignment: .leading){
                        HStack{

                            Text(LocalizedStringKey("Story highlights"))
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

                            Text(LocalizedStringKey("Keep your favourite stories on your profile"))

                            VStack{

                                ZStack{
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 30)
                                }
                                .frame(width: proxy.size.width/6,height: proxy.size.width/6)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.black).shadow(radius: 5))

                                Text(LocalizedStringKey("New"))
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
                            profileVM.isShowAllUserPost = 1
                        }
                    } label: {
                        VStack{
                            Image(systemName: "squareshape.split.3x3")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30) //not responsive
                                .foregroundColor(profileVM.isShowAllUserPost == 1 ? .black : .gray)
                            
                        }
                        .frame(width: (proxy.size.width-40)/2)
                        
                    }
                    
                    Button {
                        withAnimation {
                            profileVM.isShowAllUserPost = 0
                        }
                    } label: {
                        VStack{
                            Image(systemName: "bookmark")
                                .resizable()
                                .frame(width: 25,height: 30)    //not responsive
                                .foregroundColor(!(profileVM.isShowAllUserPost == 1) ? .black : .gray)
                        }
                    }

                }
                .padding(.top)
                
                ZStack{
                    Divider()
                        .overlay {
                            settingVM.isDarkModeEnabled ? Color.white : Color.black
                        }
                    
                    Divider()
                        .frame(width: UIScreen.main.bounds.width/2,height: 1)
                        .overlay {
                            settingVM.isDarkModeEnabled ? Color.white : Color.black
                        }
                        .offset(x: profileVM.indicatorOffset)
                } //divider
                
                TabView(selection: $profileVM.isShowAllUserPost) {
                    PostGridView(profileVM: profileVM)
                        .tag(1)
                    
                    
                    
                }
                .animation(.easeInOut, value: profileVM.isShowAllUserPost)
                .tabViewStyle(PageTabViewStyle())
                
                
                
            }
            .padding(.horizontal,20)
            .frame(minWidth: 0,maxWidth: .infinity)
            .onAppear {
                profileVM.proxySize = proxy.size
                Task{
                    try await profileVM.fetchUserPosts(UserID: authVM.currentUser?.id ?? "")
                }
                
            }
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(profileVM: ProfileViewModel())
//    }
//}
