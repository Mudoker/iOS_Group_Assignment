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

import Foundation
import SwiftUI
import AVKit
import Kingfisher
import Firebase
import FirebaseAuth

struct PostView: View {
    // Control state
    var post: Post
//    @Binding var currentUser:User
//    @Binding var userSetting:UserSetting
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var notiVM: NotificationViewModel
    @Binding var selectedPost: Post
    @Binding var isAllowComment: Bool
    
    @State var isLike = false
    @State var currentLike = 0
    @State var isArchive = false
    
    @EnvironmentObject var tabVM: TabBarViewModel
    
    var body: some View {
        VStack {
            //Post info.
            HStack
            {
            NavigationLink {
                if(post.unwrappedOwner!.id == tabVM.currentUser.id){
                    ProfileView()
                } else {
                    GuestProfileView(user: post.unwrappedOwner!)
                }
                
                   
            } label: {
                HStack {
                    // User profile image
                    if let mediaURL = URL(string: post.unwrappedOwner?.profileImageURL ?? "") {
                        
                        KFImage(mediaURL)
                            .resizable()
                            .frame(width: homeViewModel.profileImageSize, height: homeViewModel.profileImageSize)
                            .clipShape(Circle())
                            .background(Circle().foregroundColor(Color.gray))
                        
                    } else {
                        // Handle the case where the media URL is invalid or empty.
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 55, height: 55)
                        
                    }
                    
                    // Username
                    VStack (alignment: .leading, spacing: UIScreen.main.bounds.height * 0.01) {
                        if let user = post.unwrappedOwner {
                            Text(user.username.extractNameFromEmail() ?? user.username)
                                .font(Font.system(size: homeViewModel.usernameFont, weight: .semibold))
                        }
                        
                        Text(formatTimeDifference(from: post.creationDate))
                            .font(Font.system(size: homeViewModel.timeFont, weight: .medium))
                            .opacity(0.3)
                    }
                    
                    // Push view
                    Spacer()
                    
                    // Menu
                    
                }
                
            }
            .foregroundColor(tabVM.userSetting.darkModeEnabled ? .white : .black)
            
            Menu {
                if (tabVM.currentUser.id != post.ownerID) {
                    Button(action: {
                        selectedPost = post
                        homeViewModel.isBlockUserAlert = true
                        print("alerted")
                    }) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: homeViewModel.seeMoreButtonSize)
                                .padding(.trailing)
                            
                            Text("Block this user")
                        }
                    }
                    .alert("Block this user?", isPresented: $homeViewModel.isBlockUserAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Block", role: .destructive) {}
                    } message: {
                        Text("\nYou will not see this user again")
                    }
                    
                    
                    Button(action: {
                        selectedPost = post
                        homeViewModel.isRestrictUserAlert = true
                        print("alerted")}
                    ) {
                        HStack {
                            Image(systemName: "rectangle.portrait.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: homeViewModel.seeMoreButtonSize)
                                .padding(.trailing)
                            Text("Restrict this user")
                        }
                    }
                    .alert("Restrict this user?", isPresented: $homeViewModel.isSignOutAlertPresented) {
                        Button("Cancel", role: .cancel) {}
                        Button("Restrict", role: .destructive) {}
                    } message: {
                        Text("\nStop receiving notification from this user")
                    }
                }
                
                
                if (tabVM.currentUser.id == post.ownerID) {
                    // Delete post
                    Button(action: {
                        selectedPost = post
                        homeViewModel.isDeletePostAlert = true
                    }) {
                        HStack {
                            Image(systemName: "delete.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: homeViewModel.seeMoreButtonSize)
                                .padding(.trailing)
                            
                            Text("Delete Post")
                        }
                    }
                    
                    // Turn off comment
                    Button(action: {
                        selectedPost = post
                        homeViewModel.isTurnOffCommentAlert = true
                    }) {
                        HStack {
                            Image(systemName: "text.badge.xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: homeViewModel.seeMoreButtonSize)
                                .padding(.trailing)
                            Text(isAllowComment ? "Turn off comment" : "Turn on comment")
                        }
                    }
                    
                    // Edit post
                    Button(action: {
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            selectedPost = post
                                                homeViewModel.isEditNewPostOnIpad.toggle()
                                                
                                            } else {
                                                selectedPost = post
                                                print(selectedPost)
                                                homeViewModel.isEditNewPostOnIphone.toggle()
                                                
                                            }
                    }) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: homeViewModel.seeMoreButtonSize)
                                .padding(.trailing)
                            
                            Text("Edit post")
                        }
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: homeViewModel.seeMoreButtonSize)
                    .foregroundColor(.black)
            }
        }
            .padding(.horizontal)
            
            //Caption
            HStack {
                Text(post.caption ?? "")
                    .font(homeViewModel.captionFont)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Post tag
            HStack(spacing: 5) {
                ForEach(post.tag, id: \.self) { tag in
                    HStack {
                        Text("#" + tag)
                            .foregroundColor(.blue)
                            .font(.callout)
                    }
                }
                
                Spacer()
            }.padding(.horizontal)
            
            VStack {
                // Media.
                if let mediaURL = URL(string: post.mediaURL ?? "") {
                    if let mimeType = post.mediaMimeType {
                        if !mimeType.hasPrefix("image") {
                            // Handle video
                            let playerItem = AVPlayerItem(url: mediaURL)
                            let player = AVPlayer(playerItem: playerItem)
                            
                            VideoPlayer(player: player)
                                .frame(width: UIScreen.main.bounds.width)
                                .frame(minHeight: UIScreen.main.bounds.height * 0.4)
                                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                                .onAppear {
                                    player.play()
                                }
                        } else {
                            KFImage(mediaURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width)
                                .background(Color.gray)
                                .clipShape(Rectangle())
                        }
                    } else {
                        // Handle the case where the mimeType is nil
                        Text("Invalid MIME type")
                    }
                }
            }
            
            //Like/comment/archive.
            HStack (spacing: UIScreen.main.bounds.width * 0.01) {
                // Like post
                Button(action: {
                    if isLike == false {
                        Task {
                            try await homeViewModel.likePost(likerId: tabVM.currentUser.id, postId: post.id)
                            _ = try await notiVM.createInAppNotification(senderId: tabVM.currentUser.id, receiverId: post.ownerID, senderName: tabVM.currentUser.username, message: Constants.notiReact, postId: post.id, category: .react, blockedByList: [], blockedList: [])
                        }
                        isLike = true
                    } else {
                        Task {
                            try await homeViewModel.unLikePost(likerId: tabVM.currentUser.id, postId: post.id)
                        }
                        isLike = false
                    }
                }) {
                    HStack {
                        Image(systemName: "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: homeViewModel.postStatsImageSize)
                            .foregroundColor(isLike ? .pink : .black)
                            .overlay (
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: homeViewModel.postStatsImageSize)
                                    .foregroundColor(isLike ? .pink : .clear)
                            )
                    }
                    .padding(.leading)
                }
                
                Text("\(currentLike)")
                    .font(Font.system(size: homeViewModel.postStatsFontSize, weight: .light))
                    .opacity(0.6)
                    .frame(width: homeViewModel.postStatsFontSize)
                    .padding(.trailing)
                
                // Comment
                Button(action: {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        selectedPost = post
                        homeViewModel.isOpenCommentViewOnIpad.toggle()
                        homeViewModel.fetchAllComments(forPostID: post.id)
                    } else {
                        selectedPost = post
                        homeViewModel.isOpenCommentViewOnIphone.toggle()
                        homeViewModel.fetchAllComments(forPostID: post.id)
                    }
                }) {
                    HStack {
                        Image(systemName: "bubble.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: homeViewModel.postStatsImageSize)
                            .foregroundColor(.black)
                    }
                }
                
                // Push view
                Spacer()
                
                // Save post
                Button(action: {
                    if isArchive {
                        Task {
                            try await homeViewModel.unFavorPost(ownerId: tabVM.currentUser.id ,postId: post.id)
                        }
                        isArchive = false
                    } else {
                        Task {
                            try await homeViewModel.favorPost(ownerId: tabVM.currentUser.id ,postId: post.id)
                        }
                        isArchive = true
                    }
                }) {
                    HStack {
                        Image(systemName: "archivebox.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: homeViewModel.postStatsImageSize)
                            .foregroundColor(isArchive ? .yellow : .clear)
                        
                            .overlay (
                                Image(systemName: "archivebox")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: homeViewModel.postStatsImageSize)
                                    .foregroundColor(isArchive ? .black : .black)
                            )
                    }
                    .padding(.trailing)
                }
            }
            .padding(.vertical)
            
            // Comment bar
            HStack{
                if let mediaURL = URL(string: post.mediaURL ?? "") {
                    if let mimeType = post.mediaMimeType {
                        if mimeType.hasPrefix("image") {
                            KFImage(mediaURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width: homeViewModel.commentProfileImageSize, height: homeViewModel.commentProfileImageSize ) // Set the desired width and height for your circular image
                                .background(Color.gray)
                                .clipShape(Circle())
                        } else {
                            // Handle image
                            Text("Video detected!")
                        }
                    } else {
                        // Handle the case where the mimeType is nil
                        Text("Invalid MIME type")
                    }
                } else {
                    // Handle the case where the media URL is invalid or empty.
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                }
                
                Button(action: {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        selectedPost = post
                        homeViewModel.isOpenCommentViewOnIpad.toggle()
                        homeViewModel.fetchAllComments(forPostID: post.id)
                    } else {
                        selectedPost = post
                        homeViewModel.isOpenCommentViewOnIphone.toggle()
                        homeViewModel.fetchAllComments(forPostID: post.id)
                    }
                }) {
                    HStack {
                        Text("Comment")
                            .font(homeViewModel.commentTextFiledFont)
                            .padding(.horizontal)
                            .frame(height: 40) // Set the desired button height
                            
                        Spacer()

                    }
                    .background(
                        RoundedRectangle(cornerRadius: homeViewModel.commentTextFieldCornerRadius)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .foregroundColor(.primary) // Customize text color
                    .contentShape(Rectangle()) // Make the entire button area tappable
                    .multilineTextAlignment(.leading) // Set text alignment to leading
                    .frame(maxWidth: .infinity)

                }

                
            }
            .padding(.horizontal)
        }
        .onAppear {
            homeViewModel.getLikeCount(forPostID: post.id) { totalCount in
                currentLike = totalCount
            }
            
            homeViewModel.isUserLikePost(forPostID: post.id, withUserId: tabVM.currentUser.id) {isLikePost in
                isLike = isLikePost
            }
            
            isArchive = homeViewModel.isUserFavouritePost(withPostId: post.id, withUserId: tabVM.currentUser.id)
            print(isArchive)
            
            isAllowComment = post.isAllowComment
        }
    }
    
    func formatTimeDifference(from date: Timestamp) -> String {
        let currentDate = Date()
        let postDate = date.dateValue()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: postDate, to: currentDate)
        
        if let year = components.year, year > 0 {
            return "\(year)y ago"
        } else if let month = components.month, month > 0 {
            return "\(month)m ago"
        } else if let day = components.day, day > 0 {
            return "\(day)d ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)h ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)m ago"
        } else if let second = components.second, second > 0 {
            return "\(second)s ago"
        } else {
            return "Just now"
        }
    }
}

//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        Post
//    }
//}
