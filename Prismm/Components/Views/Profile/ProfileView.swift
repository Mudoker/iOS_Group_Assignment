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
import Firebase
import Kingfisher

struct ProfileView: View {
    // Control state
//    @Binding var currentUser: User
//    @Binding var userSetting: UserSetting 
    //@State var isSample = true
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var fvm = FollowViewModel()
    
    @EnvironmentObject var tabVM: TabBarViewModel
    
    var body: some View {
        VStack(alignment: .leading){

          
            VStack{
               ProfileToolBar(profileVM: profileVM)
            }
            .padding(.horizontal,15)

            
            ScrollView{
                //MARK: PROFILE INFO BLOCK
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        if let mediaURL = URL(string: tabVM.currentUser.profileImageURL ?? "") {
                            
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
                        
                        // User stats
                        VStack(alignment: .leading){
                            HStack(spacing: profileVM.infoBlockSpacing){
                                VStack{
                                    Text("0")
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Posts"))
                                    
                                }
                                
                                
                                NavigationLink {
                                    FollowView(fvm: fvm)
                                } label: {
                                    VStack{
                                        Text("\(fvm.followerList.count)")
                                            .fontWeight(.bold)
                                        Text(LocalizedStringKey("Followers"))
                                    }
                                    .frame(height: 40)
                                }
                                
                                
                                NavigationLink {
                                    FollowView(fvm: fvm)
                                } label: {
                                    VStack{
                                        Text("\(fvm.followingList.count)")
                                            .fontWeight(.bold)
                                        Text(LocalizedStringKey("Following"))
                                    }
                                    .frame(height: 40)
                                }
                                
                                
                            }
                            
                            //edit button and share button
                            HStack{
                                NavigationLink(destination: {
                                    EditProfileView()
                                }, label: {
                                    Text(LocalizedStringKey("Edit Profile"))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .frame(width: profileVM.editButtonWidth, height: profileVM.editButtonHeight)
                                            .background{
                                                Color.gray
                                                    .opacity(0.3)
                                            }
                                        .clipShape(RoundedRectangle(cornerRadius: profileVM.buttonRadiusSize))
                                })
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
                    .padding(.horizontal,15)
                    
                    // Username
                    HStack{
                        Text(tabVM.currentUser.username)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal,15)
                    //bio
                    HStack{
                        Text(tabVM.currentUser.bio!)
                    }
                    .padding(.horizontal,15)
                }
                
                //MARK: tab changing between user post and archived posts
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
                                .frame(height: profileVM.tabIconHeight) //not responsive
                                .foregroundColor(profileVM.isShowAllUserPost == 1 ? (tabVM.userSetting.darkModeEnabled ? .white : .black) : .gray)
                        }
                        
                    }
                    .frame(width: profileVM.tabButtonSize)
                    
                    Button {
                        withAnimation {
                            profileVM.isShowAllUserPost = 0
                        }
                    } label: {
                        VStack{
                            Image(systemName: "archivebox")
                                .resizable()
                                .scaledToFit()
                                .frame(height: profileVM.tabIconHeight)    //not responsive
                                .foregroundColor(!(profileVM.isShowAllUserPost == 1) ? (tabVM.userSetting.darkModeEnabled ? .white : .black) : .gray)
                        }
                    }
                    .frame(width: profileVM.tabButtonSize)
                }
                .padding(.top)
                
                // Underline line
                ZStack{
                    Divider()
                        .overlay {
                            tabVM.userSetting.darkModeEnabled ? Color.white : Color.black
                        }
                    
                    Divider()
                        .frame(width: profileVM.tabIndicatorWidth ,height: 1)
                        .overlay {
                            tabVM.userSetting.darkModeEnabled ? Color.white : Color.black
                        }
                        .offset(x: profileVM.indicatorOffset)
                }
                
                
                PostGridView( profileVM: profileVM)
                    .offset(y: -10)

            }
//            .padding(.horizontal, 10)
            
            
        }
//        .padding(.horizontal,10)
        .frame(minWidth: 0,maxWidth: .infinity)
        .onAppear {
            profileVM.proxySize = UIScreen.main.bounds.size
            Task{
                print("trigger")
                await fvm.fetchFollowData()
                
                
                
                
                try await profileVM.fetchUserPosts(UserID: tabVM.currentUser.id)
                profileVM.fetchUserFavouritePost(forUserId: tabVM.currentUser.id)
            }
        }
        .refreshable {
            Task{
                print("trigger")
                await fvm.fetchFollowData()
                
                tabVM.currentUser = try await APIService.fetchCurrentUserData() ?? User(id: "", account: "huuquoc@gmail.com")
             
                tabVM.userSetting = try await APIService.fetchCurrentSettingData()!
                try await profileVM.fetchUserPosts(UserID: tabVM.currentUser.id)
                profileVM.fetchUserFavouritePost(forUserId: tabVM.currentUser.id)
            }
        }
        .fullScreenCover(isPresented: $profileVM.isSetting) {
            SettingView(profileVM: profileVM, isSetting: $profileVM.isSetting)
        }
        .foregroundColor(tabVM.userSetting.darkModeEnabled ? .white : .black)
        .background(!tabVM.userSetting.darkModeEnabled ? .white : .black)
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(authVM: AuthenticationViewModel(), settingVM: SettingViewModel(), profileVM: ProfileViewModel())
//    }
//}
