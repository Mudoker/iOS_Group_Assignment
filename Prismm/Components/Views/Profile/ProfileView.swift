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
import Kingfisher

struct ProfileView: View {
    @State var isSample = true
    
    @EnvironmentObject var dataControllerVM : DataControllerViewModel
    
    @ObservedObject var authVM : AuthenticationViewModel
    @ObservedObject var settingVM : SettingViewModel
    @ObservedObject var profileVM : ProfileViewModel
    
    var body: some View {
        GeometryReader { proxy in
            
            VStack(alignment: .leading){
                
                ProfileToolBar(authVM: authVM, profileVM: profileVM)
                
                //MARK: PROFILE INFO BLOCK
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        if let mediaURL = URL(string: dataControllerVM.currentUser?.profileImageURL ?? "") {
                            
                            KFImage(mediaURL)
                                .resizable()
                                .frame(width: profileVM.avatarSize, height: profileVM.avatarSize)
                                .clipShape(Circle())
                                .background(Circle().foregroundColor(Color.gray))

                        } else {
                            // Handle the case where the media URL is invalid or empty.
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: profileVM.avatarSize, height: profileVM.avatarSize)
                        }
                        Spacer()
                        
                        VStack(alignment: .leading){
                            HStack(spacing: profileVM.infoBlockSpacing){
                                VStack{
                                    Text("\(dataControllerVM.currentUser?.posts.count ?? 111)")
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Posts"))
                                    
                                }
                                
                                VStack{
                                    Text("\(dataControllerVM.currentUser?.posts.count ?? 111)")
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Followers"))
                                    
                                }
                                
                                VStack{
                                    Text("\(dataControllerVM.currentUser?.posts.count ?? 111)")
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
                                        .frame(width: profileVM.editButtonWidth, height: profileVM.editButtonHeight)
                                        .background{
                                            Color.gray
                                                .opacity(0.3)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: profileVM.buttonRadiusSize))
                                }

                                Button {
                                    
                                } label: {
                                    Image("facebookIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: profileVM.editButtonHeight,height: profileVM.editButtonHeight)
                                        .clipShape(RoundedRectangle(cornerRadius: profileVM.buttonRadiusSize))
                                }
                                

                            }
                        }
                    }
                    
                    HStack{
                        Text(dataControllerVM.currentUser?.username ?? "Failed to get data")
                            .fontWeight(.bold)
                    }
                    HStack{
                        Text(dataControllerVM.currentUser?.username ?? "Failed to get data")
                    }
                }
                
                //MARK: Highlight stories
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
                
                //MARK: tab changing
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
                    }.frame(width: (proxy.size.width-40)/2)

                }
                .padding(.top)
                
                ZStack{
                    Divider()
                        .overlay {
                            dataControllerVM.userSettings!.darkModeEnabled ? Color.white : Color.black
                        }
                    
                    Divider()
                        .frame(width: UIScreen.main.bounds.width/2,height: 1)
                        .overlay {
                            dataControllerVM.userSettings!.darkModeEnabled ? Color.white : Color.black
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
                    try await profileVM.fetchUserPosts(UserID: dataControllerVM.currentUser?.id ?? "")
                }
                
            }
            .fullScreenCover(isPresented: $profileVM.isSetting) {
                SettingView(settingVM: settingVM, isSetting: $profileVM.isSetting)
            }
            .foregroundColor(dataControllerVM.userSettings!.darkModeEnabled ? .white : .black)
            .background(!dataControllerVM.userSettings!.darkModeEnabled ? .white : .black)
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(authVM: AuthenticationViewModel(), settingVM: SettingViewModel(), profileVM: ProfileViewModel())
//    }
//}
