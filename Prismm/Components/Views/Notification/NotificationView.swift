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
struct NotificationView: View {
    // Control state
    @ObservedObject var notiVM: NotificationViewModel
    @State var isDarkMode = false
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
                        NotificationRow(notification: notification, imageSize: proxy.size.width/7, isDarkMode: $isDarkMode)
                            .padding()
                    }

                    Spacer()
                }
            }
            .foregroundColor(!isDarkMode ? .black : .white)
            .background(isDarkMode ? .black : .white)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

struct NotificationRow: View {
    let notification: AppNotification
    var imageSize: CGFloat = 40
    @Binding var isDarkMode: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Notificaiton content
            HStack {
                Image("testAvt")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(notification.senderName)
                        .font(.headline)

                    Text(notification.messageContent)
                        .font(.body)
                }

                // Push view
                Spacer()

            }
        }
        .foregroundColor(!isDarkMode ? .black : .white)
        .background(isDarkMode ? .black : .white)
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(notiVM: NotificationViewModel())
    }
}
