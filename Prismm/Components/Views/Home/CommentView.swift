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
 
 Created  date: 14/09/2023
 Last modified: 16/09/2023
 Acknowledgement: None
 */

import SwiftUI
import Kingfisher
import Firebase
import FirebaseAuth

struct CommentView: View {
    // control state
    @Binding var isShowComment: Bool
    @Binding var currentUser:User
    @Binding var userSetting:UserSetting
    @Binding var isAllowComment: Bool
    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var notiVM: NotificationViewModel
    var isDarkModeEnabled: Bool
    var post: Post
    let emojis = ["👍", "❤️", "😍", "🤣", "😯", "😭", "😡", "👽", "💩", "💀"]
    
    var body: some View {
        GeometryReader { proxy in
            VStack (spacing: 0) {
                ZStack(alignment: .centerFirstTextBaseline) {
                    // Title
                    Text("Comment")
                        .font(.title2)
                        .padding(.bottom)
                        .bold()
                    
                    // Filter
                    HStack {
                        Menu {
                            Picker(selection: $homeVM.selectedCommentFilter, label: Text("Please choose a sorting option")) {
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
                
                // Show all comment
                VStack {
                    if let commentsForPost = homeVM.fetchedCommentsByPostId[post.id], !commentsForPost.isEmpty {
                        ScrollView(showsIndicators: false) {
                            ForEach(commentsForPost.sorted{$0.id < $1.id}) { comment in
                                // Comment content
                                HStack {
                                    if let profileURLString = homeVM.currentCommentor?.profileImageURL,
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
                                            Text(currentUser.username) // User Name
                                                .font(Font.system(size: homeVM.usernameFont, weight: .medium))
                                                .bold()
                                            
                                            Text(formatTimeDifference(from: comment.creationDate))
                                                .font(Font.system(size:homeVM.timeFont, weight: .medium))
                                                .opacity(0.3)
                                        }
                                        Text(comment.content) // Message
                                    }
                                    
                                    // Push view
                                    Spacer()
                                }
                                .padding(.horizontal, 5)
                                .padding(.bottom, 5)
                                .onAppear {
                                    // Start the asynchronous task when the view appears
                                    Task {
                                        do {
                                            homeVM.currentCommentor = try await APIService.fetchUser(withUserID: comment.commenterId)
                                        } catch {
                                            print("Error fetching profile image URL: \(error)")
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        // Push view
                        Spacer()
                        
                        // If no comment
                        Image(systemName: "quote.bubble")
                            .resizable()
                            .frame(width: proxy.size.width/5, height: proxy.size.width/5)
                            .opacity(0.4)
                        
                        Text("Be the first one to comment")
                            .font(.title)
                            .opacity(0.4)
                        
                        // Push view
                        Spacer()
                    }
                }
                
                // Comment field
                VStack {
                    // check if post allow comment
                    if (isAllowComment) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                // Convenient bar
                                ForEach(emojis, id: \.self) { emoji in
                                    Button(action: {
                                        homeVM.commentContent += emoji
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
                    
                    // Comment bar
                    HStack {
                        Image("testAvt")
                            .resizable()
                            .frame(width: proxy.size.width/8, height: proxy.size.width/8)
                            .clipShape(Circle())
                        
                        TextField("", text: $homeVM.commentContent, prompt:  Text("Leave a comment...").foregroundColor(isDarkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.5))
                            .font(.title3)
                        )
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .disabled(isAllowComment ? false : true)
                        .background(
                            Capsule()
                                .fill(isDarkModeEnabled ? Color.gray.opacity(0.3) : Color.white)
                        )
                        
                        // Create comment
                        Button(action: {
                            Task {
                                _ = try await homeVM.createComment(content: homeVM.commentContent, commentor: (Auth.auth().currentUser?.uid)! , postId: post.id)
                                _ = try await notiVM.createInAppNotification(senderId: currentUser.id, receiverId: post.ownerID, senderName: currentUser.username, message: Constants.notiComment, postId: post.id, category: .comment, restrictedByList: [], blockedByList: [], blockedList: [])
                                homeVM.commentContent = ""
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
            .padding(.vertical)
        }
        .foregroundColor(!isDarkModeEnabled ? .black : .white)
        .background(isDarkModeEnabled ? .black : .white)
        .edgesIgnoringSafeArea(.bottom)
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

//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView(isShowComment: .constant(true), post: P)
//    }
//}
