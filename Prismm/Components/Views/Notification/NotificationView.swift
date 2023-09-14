import SwiftUI

struct Notification: Identifiable {
    let id = UUID()
    let user: String
    let message: String
    let time: String
}

struct NotificationView: View {
    let notifications: [Notification] = [
        Notification(user: "John Doe", message: "Liked your post.", time: "1h ago"),
        Notification(user: "Jane Smith", message: "Commented on your photo.", time: "2h ago"),
        Notification(user: "Alice Johnson", message: "Started following you.", time: "3h ago"),
        // Add more notifications here
    ]
    @State var isDarkMode = false
    var body: some View {
        GeometryReader { proxy in
            ZStack {
//                    Color.white // Set the background color here

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
                        
                        ForEach(notifications) { notification in
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
    let notification: Notification
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
                    Text(notification.user)
                        .font(.headline)
                    
                    Text(notification.message)
                        .font(.body)
                }
                
                Spacer()
                Text(notification.time)
                    .font(.caption)
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
