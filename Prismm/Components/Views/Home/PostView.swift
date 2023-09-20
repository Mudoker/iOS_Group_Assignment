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

struct PostView: View {
    @Binding var post: Post
    // View model
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var settingVM: SettingViewModel
    let emojis = ["👍", "❤️", "😍", "🤣", "😯", "😭", "😡", "👽", "💩", "💀"]
    @State var isDarkModeEnabled = false

    @State var isAlert = false
    @State var newPost: Post = Post(id: "", ownerID: "", creationDate: Timestamp(), isAllowComment: true)
    var body: some View {
        VStack {
            //Post info.
            HStack {
                if let mediaURL = URL(string: post.mediaURL ?? "") {
                    if let mimeType = post.mediaMimeType {
                        if mimeType.hasPrefix("image") {
                            KFImage(mediaURL)
                                .resizable()
                                .frame(width: homeViewModel.profileImageSize, height: homeViewModel.profileImageSize)
                                .clipShape(Circle())
                                .background(Circle().foregroundColor(Color.gray))
                        } else {
                            // Handle image
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 48))
                        }
                    } else {
                        // Handle the case where the mimeType is nil
                        Text("Invalid MIME type")
                    }
                } else {
                    // Handle the case where the media URL is invalid or empty.
                    Text("Invalid media URL")
                }
                
                
                VStack (alignment: .leading, spacing: UIScreen.main.bounds.height * 0.01) {
                    if let user = post.user {
                        Text(user.username)
                            .font(Font.system(size: homeViewModel.usernameFont, weight: .semibold))
                    }
                    
                   Text(formatTimeDifference(from: post.creationDate))
                        .font(Font.system(size: homeViewModel.timeFont, weight: .medium))
                        .opacity(0.3)
                }
                
                // In building
                Spacer()
                Menu {
                    Button(action: {homeViewModel.isDeletePostAlert = true
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
                    
                    
                    Button(action: {homeViewModel.isBlockUserAlert = true}) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: homeViewModel.seeMoreButtonSize)
                                .padding(.trailing)
                            Text("Block this user")
                        }
                    }
                    
                    
                    Button(action: {homeViewModel.isRestrictUserAlert = true}) {
                        HStack {
                            Image(systemName: "rectangle.portrait.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: homeViewModel.seeMoreButtonSize)
                                .padding(.trailing)
                            Text("Restrict this user")
                        }
                    }
                    
                    Button(action: {homeViewModel.isTurnOffCommentAlert = true}) {
                        HStack {
                            Image(systemName: "text.badge.xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: homeViewModel.seeMoreButtonSize)
                                .padding(.trailing)
                            Text("Turn off comment")
                        }
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: homeViewModel.seeMoreButtonSize)
                                .padding(.trailing)
                            Text("Edit post")
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
            .alert("Delete this post?", isPresented: $homeViewModel.isDeletePostAlert) {
                Button("Cancel", role: .cancel) {
                }
                Button("Delete", role: .destructive) {
                }
            } message: {
                Text("\nThis will permanently delete this post")
            }
            .alert("Block this user?", isPresented: $homeViewModel.isBlockUserAlert) {
                Button("Cancel", role: .cancel) {
                }
                Button("Block", role: .destructive) {
                }
            } message: {
                Text("\nYou will not see this user again")
            }
            .alert("Turn off comment?", isPresented: $homeViewModel.isTurnOffCommentAlert) {
                Button("Cancel", role: .cancel) {
                }
                Button("Turn off", role: .destructive) {
                }
            } message: {
                Text("\nDisable comment for this post")
            }
            .alert("Restrict this user?", isPresented: $homeViewModel.isRestrictUserAlert) {
                Button("Cancel", role: .cancel) {
                }
                Button("Restrict", role: .destructive) {
                }
            } message: {
                Text("\nStop receiving notification from this user")
            }
            
            
            
            //Caption
            HStack {
                Text(post.id)
                    .font(homeViewModel.captionFont)
                
                Spacer()
            }
            .padding(.horizontal)
            
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
                //Image.
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
                                    // Optionally, you can play the video when it appears on the screen.
                                    player.play()
                                }
                        } else {
                            KFImage(mediaURL)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width)
                                .frame(minHeight: UIScreen.main.bounds.height * 0.4)
                                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                                .background(Color.gray)
                                .clipShape(Rectangle())
                        }
                    } else {
                        // Handle the case where the mimeType is nil
                        Text("Invalid MIME type")
                    }
                } else {
                    // Handle the case where the media URL is invalid or empty.
                    Text("Invalid media URL")
                }
            }
            
            
            //Operations menu.
            HStack (spacing: UIScreen.main.bounds.width * 0.02) {
                HStack {
                    Image(systemName: "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: homeViewModel.postStatsImageSize)
                    
                    Text("\(post.likerIDs.count)")
                        .font(Font.system(size: homeViewModel.postStatsFontSize, weight: .light))
                        .opacity(0.6)
                }
                .padding(.horizontal)
                
                Button(action: {
                    print("current post id1: " + post.id)
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        homeViewModel.isOpenCommentViewOnIpad.toggle()
                        homeViewModel.fetchAllComments(forPostID: post.id)

                    } else {
                        homeViewModel.fetchAllComments(forPostID: post.id)

                        homeViewModel.isOpenCommentViewOnIphone = true
                    }
                    print("current post id2: " + post.id)

                }) {
                    HStack {
                        Image(systemName: "bubble.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: homeViewModel.postStatsImageSize)
                            .foregroundColor(.black)
                        
                    }
                }
//                .navigationDestination(isPresented: $homeViewModel.isOpenCommentViewOnIphone) {
//                    CommentView(isDarkModeEnabled: $settingVM.isDarkModeEnabled, isShowComment: $homeViewModel.isOpenCommentViewOnIpad, homeViewModel: homeViewModel, post: $newPost)
//                        .onAppear{
//                            print("new post2: " + newPost.id)
//                        }
//                }
                .sheet(isPresented: $homeViewModel.isOpenCommentViewOnIpad) {
//                    CommentView(isDarkModeEnabled: $settingVM.isDarkModeEnabled, isShowComment: $homeViewModel.isOpenCommentViewOnIpad, homeViewModel: homeViewModel, post: $post)
                }
                .sheet(isPresented: $homeViewModel.isOpenCommentViewOnIphone) {
                    GeometryReader { proxy in
                        
                        VStack (spacing: 0) {
                            ZStack(alignment: .centerFirstTextBaseline) {
                                Text(post.id)
                                    .font(.title2)
                                    .padding(.bottom)
                                    .bold()
                                
                                HStack {
                                    Menu {
                                        Picker(selection: $homeViewModel.selectedCommentFilter, label: Text("Please choose a sorting option")) {
                                            Text("Newest").tag("Newest")
                                            Text("Oldest").tag("Oldest")
                                        }
                                    } label: {
                                        Image(systemName: "line.3.horizontal.decrease")
                                            .font(.title)
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        homeViewModel.isOpenCommentViewOnIphone = false // Close the sheet
                                    }) {
                                        Image(systemName: "xmark.circle.fill") // You can use any close button icon
                                            .font(.title)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            VStack {
                                let commentsForPost = homeViewModel.fetchedCommentsByPostId
                                if !commentsForPost.isEmpty {
                                    ScrollView(showsIndicators: false) {
                                        ForEach(commentsForPost.sorted{$0.id < $1.id}) { comment in
                                            HStack {
                                                if let profileURLString = homeViewModel.currentCommentor?.profileImageURL,
                                                       let mediaURL = URL(string: profileURLString) {
                                                        
                                                        KFImage(mediaURL)
                                                            .resizable()
                                                            .frame(width: proxy.size.width/8, height: proxy.size.width/8)
                                                            .clipShape(Circle())
                                                            .background(Circle().foregroundColor(Color.gray))
                                                } else {
                                                        Image(systemName: "person.fill")
                                                            .resizable()
                                                            .frame(width: proxy.size.width/12, height: proxy.size.width/12)
                                                            .padding()
                                                            .foregroundColor(.gray)
                                                            .background(Circle().foregroundColor(Color.gray.opacity(0.1))
                                                                .frame(width: proxy.size.width/7, height: proxy.size.width/7))
                                                }
                                                VStack(alignment: .leading) {
                                                    HStack (alignment: .firstTextBaseline) {
                                                        Text(homeViewModel.currentCommentor?.username ?? "Blank") // User Name
                                                            .font(Font.system(size: homeViewModel.usernameFont, weight: .medium))
                                                            .bold()
                                                        
                                                        Text(formatTimeDifference(from: comment.creationDate))
                                                            .font(Font.system(size: homeViewModel.timeFont, weight: .medium))
                                                            .opacity(0.3)
                                                    }
                                                    Text(comment.content) // Message
                                                }
                                                Spacer()
                                            }
                                            .padding(.horizontal, 5)
                                            .padding(.bottom, 5)
                                            .onAppear {
                                                // Start the asynchronous task when the view appears
                                                Task {
                                                    do {
                                                        homeViewModel.currentCommentor = try await APIService.fetchUser(withUserID: comment.commenterId)
                    //                                    post = try await UserService.fetchAPost(withUid: post.id)

                                                    } catch {
                                                        print("Error fetching profile image URL: \(error)")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    Spacer()
                                    Image(systemName: "quote.bubble")
                                        .resizable()
                                        .frame(width: proxy.size.width/5, height: proxy.size.width/5)
                                        .opacity(0.4)

                                    Text("Be the first one to comment")
                                        .font(.title)
                                        .opacity(0.4)
                                    Spacer()

                                }
                            }
                            
                            VStack {
                                if (post.isAllowComment) {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 0) {
                                            ForEach(emojis, id: \.self) { emoji in
                                                Button(action: {
                                                    homeViewModel.commentContent += emoji
                                                }) {
                                                    Text(emoji)
                                                        .font(.largeTitle)
                                                        .padding(8)
                                                        .background(Circle().fill(isDarkModeEnabled ? Color.gray.opacity(0.3) : Color.white))
                                                }
                                                .padding([.horizontal])
                                                .padding(.top, 8)
                                            }
                                        }
                                    }
                                } else {
                                    Text("Comment is disabled for this post")
                                        .font(.title3)
                                        .opacity(0.6)
                                        .padding(8)
                                        .padding(.top, 8)
                                }
                                
                                
                                HStack {
                                    Image("testAvt")
                                        .resizable()
                                        .frame(width: proxy.size.width/8, height: proxy.size.width/8)
                                        .clipShape(Circle())

                                        TextField("", text: $homeViewModel.commentContent, prompt:  Text("Leave a comment...").foregroundColor(isDarkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.5))
                                            .font(.title3)
                                        )
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .padding()
                                        .disabled(post.isAllowComment ? false : true)
                                        .background(
                                            Capsule()
                                                .fill(isDarkModeEnabled ? Color.gray.opacity(0.3) : Color.white)
                                        )
                                    
                                    Button(action: {
                                        Task {
            //                                print(post.id)
                                            _ = try await homeViewModel.createComment(content: homeViewModel.commentContent, commentor: "3WBgDcMgEQfodIbaXWTBHvtjYCl2", postId: post.id)
                                            homeViewModel.commentContent = ""
                                    }
                                    }) {
                                        Circle()
                                            .fill(isDarkModeEnabled ? .gray.opacity(0.3) : .white)
                                            .frame(width: proxy.size.width/8)
                                            .overlay (
                                                Image(systemName: "paperplane.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: proxy.size.width/16)
                                                    .foregroundColor(isDarkModeEnabled ? Constants.darkThemeColor : Constants.lightThemeColor)
                                            )
                                    }
                                }
                                .padding()
                                
                            }
                            .background(.gray.opacity(0.1))
                        }
                        .onAppear {
                            print("id2 :" + post.id)
                        }
                        .padding(.vertical)
                    }

                    .foregroundColor(!isDarkModeEnabled ? .black : .white)
                    .background(isDarkModeEnabled ? .black : .white)
                    .edgesIgnoringSafeArea(.bottom)
                        
                }
                
                Spacer()
                
                Image(systemName: "archivebox")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: homeViewModel.postStatsImageSize)
                    .padding(.trailing)
                
            }
            .padding(.vertical)
            
            HStack{
                if let mediaURL = URL(string: post.mediaURL ?? "") {
                    if let mimeType = post.mediaMimeType {
                        if mimeType.hasPrefix("image") {
                            AsyncImage(url: mediaURL) { media in
                                media
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
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
                    Text("Invalid media URL")
                }
                
                
                TextField("Comment..", text: $homeViewModel.commentContent)
                    .font(homeViewModel.commentTextFiledFont)
                    .padding(.horizontal) // Add horizontal padding to the text field
                    .background(
                        RoundedRectangle(cornerRadius: homeViewModel.commentTextFieldCornerRadius) // Adjust the corner radius as needed
                            .fill(Color.gray.opacity(0.1)) // Customize the background color
                            .frame(height: homeViewModel.commentTextFieldCornerRadius)
                    )
            }
            .padding(.horizontal)
        }
        .onAppear {
            newPost = post
            print("new post1: " + newPost.id)
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
