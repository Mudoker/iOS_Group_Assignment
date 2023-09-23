
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
    @State var isSample = true
    @StateObject var profileVM = ProfileViewModel()
    @ObservedObject var homeVM: HomeViewModel
    @StateObject var fvm = FollowViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            //MARK: PROFILE INFO BLOCK
            VStack(alignment: .leading){
                HStack(alignment: .center){
                    if let mediaURL = URL(string: currentUser.profileImageURL ?? "") {
                        
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
                                FollowView(fvm: fvm, currentUser: $currentUser, userSetting: $userSetting)
                            } label: {
                                VStack{
                                    Text("0")
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Followers"))
                                }
                            }
                            
                            
                            NavigationLink {
                                FollowView(fvm: fvm,currentUser: $currentUser, userSetting: $userSetting)
                            } label: {
                                VStack{
                                    Text("0")
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey("Following"))
                                }
                            }
                            
                            
                        }
                        
                        //edit button and share button
                        HStack{
                            Button {
                                
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
                    Text(currentUser.username)
                        .fontWeight(.bold)
                }
                
                HStack{
                    Text(currentUser.username)
                }
            }
            
            //MARK: Highlight stories
//            if profileVM.hasStoryHightlight {
//
//            } else {
//                VStack(alignment: .leading){
//                    HStack{
//                        Text(LocalizedStringKey("Story highlights"))
//                            .fontWeight(.bold)
//
//                        // Push view
//                        Spacer()
//
//                        Button {
//                            isSample.toggle()
//                        } label: {
//                            Image(systemName: isSample ? "chevron.up" : "chevron.down")
//                                .foregroundColor(userSetting.darkModeEnabled ? .white : .black)
//                        }
//                    }
//
//                    //Stories sample
//                    if isSample {
//                        Text("Keep your favourite stories on your profile")
//
//                        VStack{
//                            ZStack{
//                                Image(systemName: "plus")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 30)
//                            }
//                            .frame(width: profileVM.plusButtonSize,height: profileVM.plusButtonSize)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(userSetting.darkModeEnabled ? Color.white : Color.black).shadow(radius: 5))
//
//                            Text("New")
//                        }
//
//                    } else {
//                        Divider()
//                            .frame(height: 1)
//                            .overlay(userSetting.darkModeEnabled ? .white : .gray)
//                    }
//                }
//                .padding(.top,20)
//            }
            
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
            
            // Show corresponding tab
            TabView(selection: $profileVM.isShowAllUserPost) {
                PostGridView(currentUser: $currentUser, userSetting: $userSetting, profileVM: profileVM, homeVM: homeVM)
                    .tag(1)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .animation(.easeInOut, value: profileVM.isShowAllUserPost)
            .tabViewStyle(PageTabViewStyle())
        }
        .padding(.horizontal,10)
        .frame(minWidth: 0,maxWidth: .infinity)
        .onAppear {
            profileVM.proxySize = UIScreen.main.bounds.size
            Task{
                currentUser = try await APIService.fetchCurrentUserData()!
                userSetting = try await APIService.fetchCurrentSettingData()!
                try await profileVM.fetchUserPosts(UserID: currentUser.id )
                homeVM.fetchUserFavouritePost(forUserId: currentUser.id)
            }
        }
        .fullScreenCover(isPresented: $profileVM.isSetting) {
            SettingView(currentUser: $currentUser, userSetting: $userSetting, profileVM: profileVM, isSetting: $profileVM.isSetting)
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
