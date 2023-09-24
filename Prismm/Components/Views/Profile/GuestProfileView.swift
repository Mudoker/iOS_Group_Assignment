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

struct GuestProfileView: View {
    // Control state
    @State var currentUser = User(id: "default", account: "default@gmail.com")
    @State var userSetting = UserSetting(id: "default", darkModeEnabled: false, language: "en", faceIdEnabled: true, pushNotificationsEnabled: true, messageNotificationsEnabled: false)

    var user: User
    
    @State var hasFollowerWithID : Bool = false
    
    @StateObject var profileVM = GuestProfileViewModel()
    @StateObject var fvm = FollowViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            GuestProfileToolBar(currentUser: $currentUser, userSetting: $userSetting, user: user, profileVM: profileVM)
            
            ScrollView{
                //MARK: PROFILE INFO BLOCK
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        if let mediaURL = URL(string: user.profileImageURL ?? "") {
                            
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
                                
                                //MARK: not set
//                                NavigationLink {
//                                    FollowView(fvm: fvm, currentUser: $currentUser, userSetting: $userSetting)
//                                } label: {
                                    VStack{
                                        Text("\(fvm.followerList.count)")
                                            .fontWeight(.bold)
                                        Text(LocalizedStringKey("Followers"))
                                    }
//                                }
//
                                
//                                NavigationLink {
//                                    FollowView(fvm: fvm,currentUser: $currentUser, userSetting: $userSetting)
//                                } label: {
                                    VStack{
                                        Text("\(fvm.followingList.count)")
                                            .fontWeight(.bold)
                                        Text(LocalizedStringKey("Following"))
                                    }
//                                }
//                                
                                
                            }
                            
                            
                            //Follow button
                            HStack{
                                if (hasFollowerWithID){
                                    Button {
                                        Task{
                                            try await APIService.unfollowOtherUser(forUserID: user.id)
                                            hasFollowerWithID = false
                                        }
                                        
                                    } label: {
                                        
                                        
                                        Text(LocalizedStringKey("Unfollow"))
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .frame(width: profileVM.editButtonWidth, height: profileVM.editButtonHeight)
                                            .background{
                                                Color.gray
                                                    .opacity(0.3)
                                            }
                                            .clipShape(RoundedRectangle(cornerRadius: profileVM.buttonRadiusSize))
                                    }
                                }else{
                                    Button {
                                        Task{
                                            try await APIService.followOtherUser(forUserID: user.id)
                                            hasFollowerWithID = true
                                        }
                                        
                                    } label: {
                                        
                                        
                                        Text(LocalizedStringKey("Follow"))
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .frame(width: profileVM.editButtonWidth, height: profileVM.editButtonHeight)
                                            .background{
                                                Color.gray
                                                    .opacity(0.3)
                                            }
                                            .clipShape(RoundedRectangle(cornerRadius: profileVM.buttonRadiusSize))
                                    }
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
                    
                    // Username
                    HStack{
                        Text(user.username)
                            .fontWeight(.bold)
                    }
                    
                    //bio
                    HStack{
                        Text(user.bio!)
                    }
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
                                .foregroundColor(profileVM.isShowAllUserPost == 1 ? (userSetting.darkModeEnabled ? .white : .black) : .gray)
                        }
                        .frame(width: profileVM.tabButtonSize)
                    }
                    
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
                                .foregroundColor(!(profileVM.isShowAllUserPost == 1) ? (userSetting.darkModeEnabled ? .white : .black) : .gray)
                        }
                    }
                    .frame(width: profileVM.tabButtonSize)
                }
                .padding(.top)
                
                // Underline line
                ZStack{
                    Divider()
                        .overlay {
                            userSetting.darkModeEnabled ? Color.white : Color.black
                        }
                    
                    Divider()
                        .frame(width: profileVM.tabIndicatorWidth ,height: 1)
                        .overlay {
                            userSetting.darkModeEnabled ? Color.white : Color.black
                        }
                        .offset(x: profileVM.indicatorOffset)
                }
                
                
                GuestProfilePostGridView(currentUser: $currentUser, userSetting: $userSetting, profileVM: profileVM)
                    .offset(y: -10)

            }
        }
        .padding(.horizontal,10)
        .frame(minWidth: 0,maxWidth: .infinity)
        .onAppear {
            profileVM.proxySize = UIScreen.main.bounds.size
            Task{
                await fvm.fetchFollowData1(forUserID: user.id)
                currentUser = try await APIService.fetchCurrentUserData()!
                userSetting = try await APIService.fetchCurrentSettingData()!
                
                try await profileVM.fetchUserPosts(UserID: user.id )
                profileVM.fetchUserFavouritePost(forUserId: user.id)
                
                for user in fvm.followerList{
                    if user.id == currentUser.id{
                        hasFollowerWithID = true
                        break
                    }
                }
                
            }
        }
        .foregroundColor(userSetting.darkModeEnabled ? .white : .black)
        .background(!userSetting.darkModeEnabled ? .white : .black)
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(authVM: AuthenticationViewModel(), settingVM: SettingViewModel(), profileVM: ProfileViewModel())
//    }
//}
