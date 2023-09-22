//
//  Test+Notification.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 18/09/2023.
//

import SwiftUI

struct Test_Notification: View {
    @ObservedObject var notiVM = NotificationViewModel()
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    _ = try await notiVM.createInAppNotification(senderName: "Quoc", receiverId: "2ijrCbcUdXXjRRz28L5PJuDvb7u1", message: Constants.notiReact, postLink: "1qOJ9SA1GzsYdvf8LGL8", category: .react, restrictedByList: [], blockedByList: [], blockedList: [])
                    notiVM.createPushNotification()
                }
            }) {
                Text("Create Notification")
            }
        }
    }
}

struct Test_Notification_Previews: PreviewProvider {
    static var previews: some View {
        Test_Notification()
    }
}
