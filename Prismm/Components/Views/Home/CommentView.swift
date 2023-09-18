//
//  CommentView.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 14/09/2023.
//

import SwiftUI
import Kingfisher
import Firebase

struct CommentView: View {
    @Binding var isDarkMode: Bool
    @Binding var isShowComment: Bool
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var post: Post
    
    let emojis = ["👍", "❤️", "😍", "🤣", "😯", "😭", "😡", "👽", "💩", "💀"]
    
    var body: some View {
        GeometryReader { proxy in
            
            VStack (spacing: 0) {
                ZStack(alignment: .centerFirstTextBaseline) {
                    Text("Comment")
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
                            isShowComment = false // Close the sheet
                        }) {
                            Image(systemName: "xmark.circle.fill") // You can use any close button icon
                                .font(.title)
                        }
                    }
                    .padding(.horizontal)
                }
                
                VStack {
                    if let commentsForPost = homeViewModel.fetched_comments[post.id], !commentsForPost.isEmpty {
                        ScrollView(showsIndicators: false) {
                            ForEach(commentsForPost.sorted{$0.id < $1.id}) { comment in
                                HStack {
                                    if let profileURLString = homeViewModel.currentCommentor?.profileImageURL, let mediaURL = URL(string: profileURLString) {
                                        KFImage(mediaURL)
                                            .resizable()
                                            .frame(width: proxy.size.width/8, height: proxy.size.width/8)
                                            .clipShape(Circle())
                                            .background(Circle().foregroundColor(Color.gray))
                                    }
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(homeViewModel.currentCommentor?.fullName ?? "") // User Name
                                                .bold()
        //                                    Text(comment.date) // Time
                                        }
                                        Text(comment.content) // Message
                                    }
                                    Spacer()
                                }
                                .padding()
                                .onAppear {
                                    // Start the asynchronous task when the view appears
                                    Task {
                                        do {
                                            homeViewModel.currentCommentor = try await API_SERVICE.fetchUser(withUid: comment.commentor)
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
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(emojis, id: \.self) { emoji in
                                Button(action: {
                                    homeViewModel.commentContent += emoji
                                }) {
                                    Text(emoji)
                                        .font(.largeTitle)
                                        .padding(8)
                                        .background(Circle().fill(isDarkMode ? Color.gray.opacity(0.3) : Color.white))
                                }
                                .padding([.horizontal])
                                .padding(.top, 8)
                            }
                        }
                    }
                    
                    
                    HStack {
                        Image("testAvt")
                            .resizable()
                            .frame(width: proxy.size.width/8, height: proxy.size.width/8)
                            .clipShape(Circle())
                        
                        TextField("", text: $homeViewModel.commentContent, prompt:  Text("Leave a comment...").foregroundColor(isDarkMode ? .white.opacity(0.5) : .black.opacity(0.5))
                            .font(.title3)
                        )
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(
                            Capsule()
                                .fill(isDarkMode ? Color.gray.opacity(0.3) : Color.white)
                        )
                        
                        Button(action: {
                            Task {
                                _ = try await homeViewModel.createComment(content: homeViewModel.commentContent, commentor: "3WBgDcMgEQfodIbaXWTBHvtjYCl2", postId: post.id)
//                                if let newComment = newComment {
//                                    try await uploadVM.addCommentToPost(comment: newComment, postID: post.id)
//                                }
                                homeViewModel.commentContent = ""
                        }
                        }) {
                            Circle()
                                .fill(isDarkMode ? .gray.opacity(0.3) : .white)
                                .frame(width: proxy.size.width/8)
                                .overlay (
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: proxy.size.width/16)
                                        .foregroundColor(isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                                )
                        }
                    }
                    .padding()
                    
                }
                .background(.gray.opacity(0.1))
            }
            .padding(.vertical)
        }
        .foregroundColor(!isDarkMode ? .black : .white)
        .background(isDarkMode ? .black : .white)
        .edgesIgnoringSafeArea(.bottom)
    }
}

//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView(isShowComment: .constant(true), post: P)
//    }
//}
