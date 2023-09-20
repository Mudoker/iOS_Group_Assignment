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

struct HomeView: View {
    @ObservedObject var homeViewModel:HomeViewModel
    @ObservedObject var settingVM:SettingViewModel
    
    var body: some View {
        GeometryReader { proxy in
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
                    
                    
                    VStack {
                        ForEach(homeViewModel.fetchedAllPosts) { post in
                            PostView(post: post, homeViewModel: homeViewModel, settingVM: settingVM)
                                .padding(.bottom, 50)
                        }
                    }
                }
                
                .sheet(isPresented: $homeViewModel.isCreateNewPostOnIpad) {

                    CreatePostView(isNewPost: $homeViewModel.isCreateNewPostOnIpad, isDarkModeEnabled: $settingVM.isDarkModeEnabled, homeVM: homeViewModel)

                }
                .fullScreenCover(isPresented: $homeViewModel.isCreateNewPostOnIphone) {
                    CreatePostView(isNewPost: $homeViewModel.isCreateNewPostOnIphone, isDarkModeEnabled: $settingVM.isDarkModeEnabled, homeVM: homeViewModel)
                }

                .onAppear {
                    homeViewModel.proxySize = proxy.size
                    Task {
                        homeViewModel.fetchPostsRealTime()
                    }
                }
                .refreshable {
                    Task {
                        homeViewModel.fetchPostsRealTime()
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(homeViewModel: HomeViewModel(), settingVM: SettingViewModel())
    }
}
