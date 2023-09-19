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

struct NotificationView: View {
    @StateObject var notificationVM = NotificationViewModel()
    
    @State var isDarkMode = false
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "bell")
                                .font(.largeTitle)
                            
                            Text("Notification")
                                .bold()
                                .font(.largeTitle)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .overlay(isDarkMode ? .white : .gray)
                        
                        ForEach(notificationVM.fetchedAllNotifications) { notification in
                            NotificationRow(notification: notification, imageSize: proxy.size.width/7, isDarkMode: $isDarkMode)
                                .padding()
                        }
                        
                        Spacer()
                    }
            }
            .onAppear {
                notificationVM.fetchNotifcationRealTime(userId: "3WBgDcMgEQfodIbaXWTBHvtjYCl2")
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
                
                Spacer()
//                Text(notification.time)
//                    .font(.caption)
            }
        }
        .foregroundColor(!isDarkMode ? .black : .white)
        .background(isDarkMode ? .black : .white)
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
