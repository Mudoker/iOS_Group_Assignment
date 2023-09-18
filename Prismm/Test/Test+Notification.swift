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
                    _ = try await notiVM.createNotification(senderName: "Quoc" ,receiver: "3WBgDcMgEQfodIbaXWTBHvtjYCl2", message: "liked your post", category: .react)
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
