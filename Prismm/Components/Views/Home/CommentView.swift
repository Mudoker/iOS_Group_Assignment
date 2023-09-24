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
    @State var commentor = User(id: "", account: "")
    @State var isOpenCommentEditSheet = false
    @State var isEditComment = false
    @State var selectedCommentId = ""
    enum FocusedField {
        case edit, new
    }
    @FocusState private var focusedField: FocusedField?

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
                            ForEach(commentsForPost.sorted { $0.id < $1.id }) { comment in
                                // Comment content
                                HStack {
                                    if let profileURLString = commentor.profileImageURL,
                                       let mediaURL = URL(string: profileURLString) {
                                        KFImage(mediaURL)
                                            .resizable()
                                            .frame(width: proxy.size.width / 8, height: proxy.size.width / 8)
                                            .clipShape(Circle())
                                            .background(Circle().foregroundColor(Color.gray))
                                    } else {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: proxy.size.width / 12, height: proxy.size.width / 12)
                                            .padding()
                                            .foregroundColor(.gray)
                                            .background(Circle().foregroundColor(Color.gray.opacity(0.1))
                                                .frame(width: proxy.size.width / 7, height: proxy.size.width / 7))
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        HStack(alignment: .firstTextBaseline) {
                                            Text(comment.unwrapCommentor?.username ?? "") // User Name
                                                .font(Font.system(size: homeVM.usernameFont, weight: .medium))
                                                .bold()
                                            
                                            Text(formatTimeDifference(from: comment.creationDate))
                                                .font(Font.system(size: homeVM.timeFont, weight: .medium))
                                                .opacity(0.3)
                                            
                                            Spacer()
                                            
                                            if comment.commenterId == currentUser.id {
                                                Button(action: {
                                                    selectedCommentId = comment.id
                                                    isOpenCommentEditSheet = true
                                                }){
                                                    Image(systemName: "ellipsis")
                                                        .font(.title3)
                                                }
                                                .sheet(isPresented: $isOpenCommentEditSheet) {
                                                    VStack {
                                                        Button(action: {
                                                            isEditComment = true
                                                            focusedField = .edit
                                                        }) {
                                                            HStack {
                                                                Image(systemName: "pencil.circle")
                                                                    .font(.title3)
                                                                
                                                                Text("Edit comment")
                                                                
                                                                Spacer()
                                                            }
                                                            .padding()
                                                        }
                                                        
                                                        Divider()
                                                        
                                                        Button (action: {
                                                            homeVM.isDeleteCommentAlert = true
                                                        }) {
                                                            HStack {
                                                                Image(systemName: "trash.circle")
                                                                    .font(.title3)
                                                                
                                                                Text("Delete comment")
                                                                
                                                                Spacer()
                                                            }
                                                            .padding()
                                                        }
                                                        .alert("Delete this comment?", isPresented: $homeVM.isDeleteCommentAlert) {
                                                            Button("Cancel", role: .cancel) {
                                                                print(comment.id)
                                                            }
                                                            Button("Delete", role: .destructive) {
                                                                isOpenCommentEditSheet = false
                                                                // Remove the comment from the array
                                                                if let _ = commentsForPost.firstIndex(where: { $0.id == selectedCommentId }) {                          withAnimation {
                                                                        homeVM.fetchedCommentsByPostId[post.id] = nil
                                                                    }
                                                                }
                                                                
                                                                Task {
                                                                    try await homeVM.deleteComment(commentID: selectedCommentId)
                                                                }
                                                            }
                                                        } message: {
                                                            Text("\nPermanently delete this comment.")
                                                        }
                                                    }
                                                    .presentationDetents([.height(150)])
                                                }
                                            }
                                        }
                                        
                                        if (isEditComment && comment.commenterId == currentUser.id && comment.id == selectedCommentId) {
                                            HStack {
                                                TextField("", text: $homeVM.editCommentContent, prompt:  Text(comment.content ?? "").foregroundColor(isDarkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.5))
                                                )
                                                .focused($focusedField, equals: .edit)
                                                .onAppear {
                                                    homeVM.editCommentContent = comment.content ?? ""
                                                }
                                                .autocorrectionDisabled(true)
                                                .textInputAutocapitalization(.never)
                                                .padding(8)
                                                .background(
                                                    Capsule()
                                                        .fill(!isDarkModeEnabled ? Color.gray.opacity(0.3) : Color.white)
                                                )
                                                
                                                // Create comment
                                                Button(action: {
                                                    if !homeVM.editCommentContent.isEmpty {
                                                        // update the comment from the array
                                                        if let commentToUpdate = commentsForPost.first(where: { $0.id == comment.id }) {
                                                            // Create a modified version of the comment with updated content
                                                            var updatedComment = commentToUpdate
                                                            updatedComment.content = homeVM.editCommentContent
                                                            
                                                            // Optionally, use withAnimation to animate the update
                                                            withAnimation {
                                                                // Assuming that you want to update the dictionary after updating the content
                                                                // Remove the old comment and add the updated comment
                                                                homeVM.fetchedCommentsByPostId[post.id]?.remove(commentToUpdate)
                                                                homeVM.fetchedCommentsByPostId[post.id]?.insert(updatedComment)
                                                            }
                                                        }

                                                        isEditComment = false
                                                        focusedField = .new

                                                        Task {
                                                            try await homeVM.editCurrentComment(commentID: comment.id, newContent: homeVM.editCommentContent)
                                                            homeVM.editCommentContent = ""
                                                        }
                                                    } else {
                                                        homeVM.editCommentContent = comment.content ?? ""
                                                        
                                                        isEditComment = false
                                                        focusedField = .new
                                                    }
                                                }) {
                                                    Circle()
                                                        .fill(!isDarkModeEnabled ? .gray.opacity(0.3) : .white)
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
                                            .onAppear {
                                                isOpenCommentEditSheet = false
                                            }
                                            
                                        } else {
                                            Text(comment.content ?? "") // Message
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 5)
                                .padding(.bottom, 5)
                            }
                        }
                    } else {
                        // If no comments
                        Spacer()
                        
                        Image(systemName: "quote.bubble")
                            .resizable()
                            .frame(width: proxy.size.width / 5, height: proxy.size.width / 5)
                            .opacity(0.4)
                        
                        Text("Be the first one to comment")
                            .font(.title)
                            .opacity(0.4)
                        
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
                                        if isEditComment {
                                            homeVM.editCommentContent += emoji
                                        } else {
                                            homeVM.commentContent += emoji
                                        }
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
                    
                    if !isEditComment {
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
                            .focused($focusedField, equals: .new)
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
                                    _ = try await notiVM.createInAppNotification(senderId: currentUser.id, receiverId: post.ownerID, senderName: currentUser.username, message: Constants.notiComment, postId: post.id, category: .comment, blockedByList: [], blockedList: [])
                                    
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
                }
                .background(.gray.opacity(0.1))
            }
            .padding(.vertical)
        }
        .foregroundColor(!isDarkModeEnabled ? .black : .white)
        .background(isDarkModeEnabled ? .black : .white)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            focusedField = .new
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

//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView(isShowComment: .constant(true), post: P)
//    }
//}
