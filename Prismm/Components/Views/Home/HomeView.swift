//
//  Home.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 08/09/2023.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = HomeViewModel()
    @ObservedObject var uploadVM = UploadPostViewModel()

    var body: some View {
        GeometryReader {proxy in
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack (spacing: 40) {
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
                //.navigationBarTitle("", displayMode: .inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image("logolight")
                            .resizable()
                        .frame(width: homeViewModel.appLogoSize, height: homeViewModel.appLogoSize)

                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                          NavigationLink(destination: EmptyView()) {
                                Image(systemName: "message")
                                    .resizable()
                                    .scaledToFill()
                                    .font(.system(size: homeViewModel.messageLogoSize))
                            }
                    }
                })
                .onAppear {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        homeViewModel.storyViewSizeWidth = proxy.size.width * 0.2
                        homeViewModel.storyViewSizeHeight = proxy.size.width * 0.23
                        homeViewModel.appLogoSize = proxy.size.width/6
                        homeViewModel.messageLogoSize = proxy.size.width * 0.06
                        homeViewModel.profileImageSize = proxy.size.width * 0.15
                        homeViewModel.seeMoreButtonSize = proxy.size.width * 0.04
                        homeViewModel.postStatsFontSize = proxy.size.width * 0.04
                        homeViewModel.postStatsImageSize = proxy.size.width * 0.05
                        homeViewModel.commentProfileImage = proxy.size.width * 0.1
                        homeViewModel.commentTextFieldSizeHeight = proxy.size.width * 0.1
                    } else {
                        homeViewModel.storyViewSizeWidth = proxy.size.width * 0.15
                        homeViewModel.storyViewSizeHeight = proxy.size.width * 0.15
                        homeViewModel.appLogoSize = proxy.size.width/14
                        homeViewModel.messageLogoSize = 20
                        homeViewModel.profileImageSize = proxy.size.width * 0.1
                        homeViewModel.seeMoreButtonSize = proxy.size.width * 0.04
                        homeViewModel.postStatsFontSize = proxy.size.width * 0.03
                        homeViewModel.postStatsImageSize = proxy.size.width * 0.04
                        homeViewModel.commentProfileImage = proxy.size.width * 0.08
                        homeViewModel.commentTextFieldSizeHeight = proxy.size.width * 0.08
                        homeViewModel.commentTextFiledFont = .title
                        homeViewModel.usernameFont = 35
                        homeViewModel.captionFont = .largeTitle
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
