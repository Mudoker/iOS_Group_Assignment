import SwiftUI

struct NotificationView: View {
    @StateObject var notiVM = NotificationViewModel()
    
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
                        
                        ForEach(notiVM.fetched_noti) { notification in
                            NotificationRow(notification: notification, imageSize: proxy.size.width/7, isDarkMode: $isDarkMode)
                                .padding()
                        }
                        
                        Spacer()
                    }
            }
            .onAppear {
                notiVM.fetchNotifcationRealTime(userId: "3WBgDcMgEQfodIbaXWTBHvtjYCl2")
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
                    Text(notification.senderName)
                        .font(.headline)

                    Text(notification.message)
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
