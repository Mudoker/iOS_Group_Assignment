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
 
 Created  date: 08/09/2023
 Last modified: 13/09/2023
 Acknowledgement: None
 */
import SwiftUI
import Firebase
struct HomeView: View {
    // control state
//    @State var currentUser = User(id: "default", account: "default@gmail.com")
//    @State var userSetting = UserSetting(id: "default", darkModeEnabled: false, language: "en", faceIdEnabled: true, pushNotificationsEnabled: true, messageNotificationsEnabled: false)
    
    
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var notiVM: NotificationViewModel
    
    @State var isSelectedPostAllowComment = false
    
    @EnvironmentObject var tabVM: TabBarViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    ZStack(alignment: .top) {
                        // App logo
                        HStack {
                            Image(tabVM.userSetting.darkModeEnabled ? "logodark.text" : "logolight.text")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: homeViewModel.appLogoSize, height: homeViewModel.appLogoSize)
                                .padding(.leading)
                            Spacer()
                        }
                        .frame(height: homeViewModel.appLogoSize / 4)
                        
                        // Create new post
                        HStack {
                            Spacer()
                            
                            Button(action: {if UIDevice.current.userInterfaceIdiom == .pad {
                                homeViewModel.isCreateNewPostOnIpad.toggle()
                            } else {
                                homeViewModel.isCreateNewPostOnIphone.toggle()
                            }}) {
                                if UIDevice.current.userInterfaceIdiom == .phone{
                                    Image(systemName: "plus.app")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: homeViewModel.messageLogoSize, height: homeViewModel.messageLogoSize)
                                        .foregroundColor(tabVM.userSetting.darkModeEnabled ? Constants.darkThemeColor.opacity(0.8) : Constants.lightThemeColor.opacity(0.8))
                                        .padding()
                                }
                                else{
                                    Image(systemName: "plus.app")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:homeViewModel.messageLogoSize , height: homeViewModel.messageLogoSize)
                                        .foregroundColor(tabVM.userSetting.darkModeEnabled ? Constants.darkThemeColor.opacity(0.8) : Constants.lightThemeColor.opacity(0.8))
                                        .padding()
                                }
                            }
                            
                        }
                        .frame(height: homeViewModel.appLogoSize / 4)
                        
                    }
                    ScrollView(.vertical, showsIndicators: false) {

                       
                        
                        // Post view
                        if !homeViewModel.isFetchingPost {
                            VStack {
                                ForEach(homeViewModel.fetchedAllPosts) { post in
                                    PostView(post: post, homeViewModel: homeViewModel, notiVM: notiVM, selectedPost: $homeViewModel.selectedPost, isAllowComment: $isSelectedPostAllowComment)
                                        .padding(.bottom, 50)
                                }
                                
                                // End of view
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40) // Adjust the size as needed
                                    .overlay(
                                        LinearGradient(
                                            gradient: Gradient(
                                                colors: tabVM.userSetting.darkModeEnabled ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight
                                            ),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                        .mask(Image(systemName: "checkmark.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                        )
                                    )
                                    .padding(.top)
                                
                                Text("You have caught up !")
                                    .font(.title)
                                    .foregroundColor(tabVM.userSetting.darkModeEnabled ? Constants.darkThemeColor :  Constants.lightThemeColor )
                                
                                Text("You've seen all new posts")
                                    .opacity(0.5)
                                    .padding(.bottom)
                            }
                        }
                        
                    }
                    .fullScreenCover(isPresented: $homeViewModel.isEditNewPostOnIphone){
                        EditPostView(homeVM: homeViewModel, isEditPost: $homeViewModel.isEditNewPostOnIphone, post: $homeViewModel.selectedPost)
                                        }
                    
                    .sheet(isPresented: $homeViewModel.isCreateNewPostOnIpad) {
                        CreatePostView(homeVM: homeViewModel, isNewPost: $homeViewModel.isCreateNewPostOnIpad, isDarkModeEnabled: tabVM.userSetting.darkModeEnabled, notiVM: notiVM )
                    }
                    .fullScreenCover(isPresented: $homeViewModel.isCreateNewPostOnIphone) {
                        CreatePostView(homeVM: homeViewModel, isNewPost: $homeViewModel.isCreateNewPostOnIphone, isDarkModeEnabled: tabVM.userSetting.darkModeEnabled, notiVM: notiVM)
                    }
                    .sheet(isPresented: $homeViewModel.isOpenCommentViewOnIpad) {
                        CommentView(isShowComment: $homeViewModel.isOpenCommentViewOnIpad, isAllowComment: $isSelectedPostAllowComment, homeVM: homeViewModel, notiVM: notiVM, isDarkModeEnabled: tabVM.userSetting.darkModeEnabled, post: homeViewModel.selectedPost)
                    }
                    .fullScreenCover(isPresented: $homeViewModel.isOpenCommentViewOnIphone) {
                        CommentView(isShowComment: $homeViewModel.isOpenCommentViewOnIphone, isAllowComment: $isSelectedPostAllowComment, homeVM: homeViewModel, notiVM: notiVM, isDarkModeEnabled: tabVM.userSetting.darkModeEnabled, post: homeViewModel.selectedPost)
                    }
                    .onAppear {
                        homeViewModel.proxySize = proxy.size
                    }
                    .refreshable {
                        homeViewModel.isFetchingPost = true
                        Task {
                            try await homeViewModel.fetchPosts()
                            homeViewModel.isFetchingPost = false
                        }
                    }
                }
                
                // Loading indicator
                if homeViewModel.isFetchingPost {
                    Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
                    ProgressView("Loading ...")
                }
                
            }
        }
        .background(tabVM.userSetting.darkModeEnabled ?.black: .white)
        .alert("Block this user?", isPresented: $homeViewModel.isBlockUserAlert) {
            Button("Cancel", role: .cancel) {
            }
            Button("Block", role: .destructive) {
                Task{
                    try await APIService.blockOtherUser(forUserID: homeViewModel.selectedPost.ownerID)

                }
                print("blocked")
            }
        } message: {
            Text("\nYou will not see this user again")
        }
        
        .alert("Restrict this user?", isPresented: $homeViewModel.isRestrictUserAlert) {
            Button("Cancel", role: .cancel) {
            }
            Button("Restrict", role: .destructive) {
                Task{
                    try await APIService.restrictOtherUser(forUserID: homeViewModel.selectedPost.ownerID)
                    //try await APIService.followOtherUser(forUserID: homeViewModel.currentPost!.ownerID)
//                    try await APIService.unfollowOtherUser(forUserID: homeViewModel.currentPost!.ownerID)
                }
                print("restricted")
            }
        } message: {
            Text("\nStop receiving notification from this user")
        }
        
        .alert(isSelectedPostAllowComment ? "Turn off comment for this post?" : "Turn on comment for this post?", isPresented: $homeViewModel.isTurnOffCommentAlert) {
            Button("Cancel", role: .cancel) {
                print(isSelectedPostAllowComment)
            }
            Button(isSelectedPostAllowComment ? "Turn off" : "Turn on", role: .destructive) {
                isSelectedPostAllowComment = !isSelectedPostAllowComment
                if let index = homeViewModel.fetchedAllPosts.firstIndex(where: { $0 == homeViewModel.selectedPost }) {
                    // Now you have the index of selectedPost in the array
                    homeViewModel.fetchedAllPosts[index].isAllowComment = isSelectedPostAllowComment
                    print(homeViewModel.fetchedAllPosts[index].isAllowComment)
                }
                
                Task{
                    try await homeViewModel.toggleCommentOnPost(postID: homeViewModel.selectedPost.id ,isDisable: isSelectedPostAllowComment)
                }
            }
        } message: {
            Text(isSelectedPostAllowComment ? "\nTurn off comment for this post" : "\nTurn on comment for this post" )
        }
        .alert("Delete this post?", isPresented: $homeViewModel.isDeletePostAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    //print(selectedPost.id)
                    withAnimation {
                        if let index = homeViewModel.fetchedAllPosts.firstIndex(where: { $0 == homeViewModel.selectedPost }) {
                            // Now you have the index of selectedPost in the array
                            homeViewModel.fetchedAllPosts.remove(at: index)
                        }
                    }
                   
                    try await homeViewModel.deletePost(postID: homeViewModel.selectedPost.id)
                }
            }
        } message: {
            Text("\nThis will permanently delete this post")
        }
        .onAppear{
            Task{
                tabVM.currentUser = try await APIService.fetchCurrentUserData() ?? User(id: "default", account: "default@gmail.com")
                tabVM.userSetting = try await APIService.fetchCurrentSettingData() ?? UserSetting(id: "default", darkModeEnabled: false, language: "en", faceIdEnabled: false, pushNotificationsEnabled: false, messageNotificationsEnabled: false)
                notiVM.fetchNotifcationRealTime(userId: tabVM.currentUser.id)
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(dataControllerVM: HomeViewModel(), authVM: AuthenticationViewModel(), settingVM: SettingViewModel(), homeViewModel: <#HomeViewModel#>)
//    }
//}
