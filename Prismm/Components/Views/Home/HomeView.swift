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
    @EnvironmentObject var dataControllerVM: DataControllerViewModel
    
    @ObservedObject var authVM :AuthenticationViewModel
    @ObservedObject var settingVM:SettingViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @State var selectedPost = Post(id: "", ownerID: "", creationDate: Timestamp(), isAllowComment: true)
        @State var isLoadingPost = false
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    ZStack(alignment: .top) {
                        HStack {
                            Image("logolight.text")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: homeViewModel.appLogoSize, height: homeViewModel.appLogoSize)
                                .padding(.leading)
                            Spacer()
                        }
                        .frame(height: homeViewModel.appLogoSize / 4)
                        
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
                                        .foregroundColor(.pink.opacity(0.8))
                                        .padding()
                                }
                                else{
                                    Image(systemName: "plus.app")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:homeViewModel.messageLogoSize , height: homeViewModel.messageLogoSize)
                                        .foregroundColor(.pink.opacity(0.8))
                                        .padding()
                                }
                            }
                            
                        }
                        .frame(height: homeViewModel.appLogoSize / 4)
                        
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        Divider()
                                    
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 40) {
                                ForEach(0..<5, id: \.self) { _ in
                                    StoryView()
                                        .frame(width: homeViewModel.storyViewWidth, height: homeViewModel.storyViewHeight)
                                }
                            }
                            .padding()
                        }
                        
                        
                        if !isLoadingPost {
                            VStack {
                                    ForEach(homeViewModel.fetchedAllPosts) { post in
                                        PostView(post: post, homeViewModel: homeViewModel, settingVM: settingVM, select: $selectedPost)
                                            .padding(.bottom, 50)
                                    }
                                    
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 40, height: 40) // Adjust the size as needed
                                        .overlay(
                                            LinearGradient(
                                                gradient: Gradient(
                                                    colors: settingVM.isDarkModeEnabled ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight
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
                                        .foregroundColor(.pink)
                                    
                                    Text("You've seen all new posts from creators you follow")
                                        .opacity(0.5)
                                        .padding(.bottom)
                            }
                        }
                        
                    }
                    .sheet(isPresented: $homeViewModel.isEditNewPostOnIpad){
                        EditPostView(authVM: authVM, settingVM: settingVM, homeVM: homeViewModel, isEditPost: $homeViewModel.isEditNewPostOnIpad, isDarkModeEnabled: dataControllerVM.userSettings?.darkModeEnabled ?? false, post : selectedPost)
                    }
                    .fullScreenCover(isPresented: $homeViewModel.isEditNewPostOnIphone){
                        EditPostView(authVM: authVM, settingVM: settingVM, homeVM: homeViewModel, isEditPost: $homeViewModel.isEditNewPostOnIphone, isDarkModeEnabled: dataControllerVM.userSettings?.darkModeEnabled ?? false, post : selectedPost)
                    }
                    .sheet(isPresented: $homeViewModel.isCreateNewPostOnIpad) {

                        CreatePostView(authVM: authVM, settingVM: settingVM, homeVM: homeViewModel, isNewPost: $homeViewModel.isCreateNewPostOnIpad, isDarkModeEnabled: dataControllerVM.userSettings?.darkModeEnabled ?? false)

                    }
                    .fullScreenCover(isPresented: $homeViewModel.isCreateNewPostOnIphone) {
                        CreatePostView(authVM: authVM, settingVM: settingVM, homeVM: homeViewModel, isNewPost: $homeViewModel.isCreateNewPostOnIphone, isDarkModeEnabled: dataControllerVM.userSettings?.darkModeEnabled ?? false)
                    }
                    
                    .sheet(isPresented: $homeViewModel.isOpenCommentViewOnIpad) {
                        CommentView(isDarkModeEnabled: dataControllerVM.userSettings!.darkModeEnabled, isShowComment: $homeViewModel.isOpenCommentViewOnIpad, homeViewModel: homeViewModel, post: selectedPost)
                    }
                    .fullScreenCover(isPresented: $homeViewModel.isOpenCommentViewOnIphone) {
                        CommentView(isDarkModeEnabled: dataControllerVM.userSettings!.darkModeEnabled, isShowComment: $homeViewModel.isOpenCommentViewOnIphone, homeViewModel: homeViewModel, post: selectedPost)
                    }

                    .onAppear {
                        homeViewModel.proxySize = proxy.size
                        isLoadingPost = true
                        Task {
                            homeViewModel.fetchUserFavouritePost(forUserId: "ao2PKDpap4Mq7M5cn3Nrc1Mvoa42")
                            try await homeViewModel.fetchPosts()
                            isLoadingPost = false
                        }
                    }
                    .refreshable {
                        isLoadingPost = true
                        Task {
                            try await homeViewModel.fetchPosts()
                            isLoadingPost = false
                        }
                    }
                }
                
                if isLoadingPost {
                    Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
                    ProgressView("Fetching posts...")
                }
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(dataControllerVM: HomeViewModel(), authVM: AuthenticationViewModel(), settingVM: SettingViewModel(), homeViewModel: <#HomeViewModel#>)
//    }
//}
