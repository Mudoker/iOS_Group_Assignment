////
////  Test+Notification.swift
////  Prismm
////
////  Created by Quoc Doan Huu on 18/09/2023.
////
//
//import SwiftUI
//
//struct Test_Notification: View {
//    @ObservedObject var notiVM = NotificationViewModel()
//    var pushNotification = NotificationManager()
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                Task {
//                    _ = try await notiVM.createInAppNotification(senderName: "Quoc", receiverId: "2ijrCbcUdXXjRRz28L5PJuDvb7u1", message: Constants.notiReact, postLink: "1qOJ9SA1GzsYdvf8LGL8", category: .react, restrictedByList: [], blockedByList: [], blockedList: [])
//                    _ = try await notiVM.createInAppNotification(senderName: "Viet", receiverId: "2ijrCbcUdXXjRRz28L5PJuDvb7u1", message: Constants.notiFollow, postLink: "1qOJ9SA1GzsYdvf8LGL8", category: .react, restrictedByList: [], blockedByList: [], blockedList: [])
//                    _ = try await notiVM.createInAppNotification(senderName: "QAnh", receiverId: "2ijrCbcUdXXjRRz28L5PJuDvb7u1", message: Constants.notiComment, postLink: "1qOJ9SA1GzsYdvf8LGL8", category: .react, restrictedByList: [], blockedByList: [], blockedList: [])
//                    _ = try await notiVM.createInAppNotification(senderName: "Ngoc", receiverId: "2ijrCbcUdXXjRRz28L5PJuDvb7u1", message: Constants.notiMention, postLink: "1qOJ9SA1GzsYdvf8LGL8", category: .react, restrictedByList: [], blockedByList: [], blockedList: [])
//                }
//            }) {
//                Text("Create Notification")
//            }
//            Button(action: {
//                pushNotification.requestNotificationPermission()
//            }) {
//                Text("Request Notification Permission")
//            }
//            Button(action: {
//                pushNotification.scheduleNotification(at: Date(), withTimeInterval: (Double(10) + 0.2), titled: "Prismm", andBody: "\("Quoc") \("Hello")")
//            }) {
//                Text("Create Push Notification")
//            }
//        }
//        .onAppear {
//            notiVM.fetchNotifcationRealTime(userId: "2ijrCbcUdXXjRRz28L5PJuDvb7u1")
//        }
//    }
//}
//
//struct Test_Notification_Previews: PreviewProvider {
//    static var previews: some View {
//        Test_Notification()
//    }
//}
