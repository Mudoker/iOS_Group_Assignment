// Home.swift
// Prismm
//
// Created by Nguyen Dinh Viet on 08/09/2023.

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = HomeViewModel()
    @ObservedObject var uploadVM = UploadPostViewModel()
    @State var isNewPost = false

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
              
                VStack {
                    ZStack(alignment: .top) {
                        HStack {
//                            Spacer()
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
                            
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: homeViewModel.messageLogoSize, height: homeViewModel.messageLogoSize)
                                .foregroundColor(.pink.opacity(0.8))
                                .padding()
                        }
                        .frame(height: homeViewModel.appLogoSize / 4)

                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        Divider()
                            HStack {
                                Image("testAvt")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: proxy.size.width / 7, height: proxy.size.width / 7)
                                    .clipShape(Circle())

                                Button(action: { isNewPost.toggle() }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: proxy.size.width / 20)
                                            .frame(height: proxy.size.width / 9)
                                            .foregroundColor(.black.opacity(0.04))
                                            .overlay(
                                                HStack {
                                                    Text("Share your updates...")
                                                        .foregroundColor(.gray)
                                                        .font(.headline)
                                                        .padding(.horizontal, 20)
                                                    Spacer()
                                                }
                                            )
                                    }
                                }
                            }
                            .padding([.horizontal])
                            .padding(.vertical)

                            Divider()

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 40) {
                                    ForEach(0..<5, id: \.self) { _ in
                                        StoryView()
                                            .frame(width: homeViewModel.storyViewSizeWidth, height: homeViewModel.storyViewSizeHeight)
                                    }
                                }
                                .padding()
                            }

                            Divider()

                            VStack {
                                ForEach(uploadVM.fetched_post) { post in
                                    PostView(post: post, homeViewModel: homeViewModel, uploadVM: uploadVM)
                                        .padding(.bottom, 50)
                                }
                            }
                        }

                        .fullScreenCover(isPresented: $isNewPost) {
                            CreatePostView(isNewPost: $isNewPost)
                        }
    //                    .toolbar(content: {
    //                        ToolbarItem(placement: .principal) {
                                
    //                        }
    //                        ToolbarItem(placement: .navigationBarTrailing) {
    //                            // Add your trailing toolbar item content here
    //                        }
    //                    })
                        .onAppear {
                            // Customize view components based on device type and size
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                homeViewModel.storyViewSizeWidth = proxy.size.width * 0.2
                                homeViewModel.storyViewSizeHeight = proxy.size.width * 0.23
                                homeViewModel.appLogoSize = proxy.size.width / 2
                                homeViewModel.messageLogoSize = proxy.size.width / 14
                                homeViewModel.profileImageSize = proxy.size.width * 0.15
                                homeViewModel.seeMoreButtonSize = proxy.size.width * 0.04
                                homeViewModel.postStatsFontSize = proxy.size.width * 0.04
                                homeViewModel.postStatsImageSize = proxy.size.width * 0.05
                                homeViewModel.commentProfileImage = proxy.size.width * 0.1
                                homeViewModel.commentTextFieldSizeHeight = proxy.size.width * 0.1
                            } else {
                                homeViewModel.storyViewSizeWidth = proxy.size.width * 0.15
                                homeViewModel.storyViewSizeHeight = proxy.size.width * 0.15
                                homeViewModel.appLogoSize = proxy.size.width / 7
                                homeViewModel.messageLogoSize = proxy.size.width * 0.06
                                homeViewModel.profileImageSize = proxy.size.width * 0.1
                                homeViewModel.seeMoreButtonSize = proxy.size.width * 0.04
                                homeViewModel.postStatsFontSize = proxy.size.width * 0.03
                                homeViewModel.postStatsImageSize = proxy.size.width * 0.04
                                homeViewModel.commentProfileImage = proxy.size.width * 0.08
                                homeViewModel.commentTextFieldSizeHeight = proxy.size.width * 0.08
                                homeViewModel.commentTextFiledFont = .title
                                homeViewModel.usernameFont = 25
                                homeViewModel.captionFont = .title
                            }
                        }
                        .refreshable {
                            Task {
                                try await uploadVM.fetchPost()
                            }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
