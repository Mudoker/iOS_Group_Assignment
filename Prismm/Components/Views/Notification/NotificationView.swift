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

 Created  date: 11/09/2023
 Last modified: 18/09/2023
 Acknowledgement: None
 */
import SwiftUI
import Firebase
import FirebaseAuth
import Kingfisher

struct NotificationView: View {
    // Control state
    @ObservedObject var notiVM: NotificationViewModel
    @State var isDarkMode = false
    @EnvironmentObject var tabVM : TabBarViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(alignment: .leading) {
                    // Title
                    HStack {
                        Image(systemName: "bell")
                            .font(.title)

                        Text("Notification")
                            .bold()
                            .font(.largeTitle)
                    }
                    .padding(.horizontal)

                    // Separator
                    Divider()
                        .overlay(isDarkMode ? .white : .gray)

                    // Content
                    ForEach(notiVM.fetchedAllNotifications) { notification in
                        NotificationRow(notification: notification, imageSize: proxy.size.width/7, isDarkMode: $isDarkMode, sender: User(id: "", account: ""))
                            .padding()
                    }

                    Spacer()
                }
            }
            .foregroundColor(tabVM.userSetting.darkModeEnabled ? .white : .black)
            .background(tabVM.userSetting.darkModeEnabled ? .black : .white)
            .preferredColorScheme(tabVM.userSetting.darkModeEnabled ? .dark : .light)
        }
    }
}

struct NotificationRow: View {
    let notification: AppNotification
    var imageSize: CGFloat = 40
    @State var unwrapPost = Post(id: "", ownerID: "", creationDate: Timestamp(), isAllowComment: false)
    @Binding var isDarkMode: Bool
    @State var isShowPost = false
    @EnvironmentObject var tabVM : TabBarViewModel
    @State var sender: User
    var body: some View {
        Button (action: {
            Task {
                unwrapPost = try await APIService.fetchPost(withPostID: notification.postId)
                isShowPost = true
            }
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // Notificaiton content
                HStack {
                    if let mediaURL = URL(string: sender.profileImageURL ?? "") {
                        KFImage(mediaURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(Circle())
                        
                    } else {
                        // Handle the case where the media URL is invalid or empty.
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(Circle())
                    }

                    VStack(alignment: .leading) {
                        Text(notification.senderName)
                            .font(.headline)

                        Text(LocalizedStringKey(stringLiteral: notification.messageContent) )
                            .font(.body)
                    }

                    // Push view
                    Spacer()

                }
            }
            .foregroundColor(tabVM.userSetting.darkModeEnabled ? .white : .black)
            .background(tabVM.userSetting.darkModeEnabled ? .black : .white)
            .onAppear {
                Task {
                    sender = try await APIService.fetchUser(withUserID: notification.senderId)
                }
            }
        }
//        .navigationDestination(isPresented: $isShowPost, destination: PostView(post: unwrapPost, currentUser: , userSetting: <#T##Binding<UserSetting>#>, homeViewModel: <#T##HomeViewModel#>, notiVM: <#T##NotificationViewModel#>, selectedPost: <#T##Binding<Post>#>, isAllowComment: <#T##Binding<Bool>#>))
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(notiVM: NotificationViewModel())
    }
}
