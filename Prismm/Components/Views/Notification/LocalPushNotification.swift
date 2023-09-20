//
//  LocalPushNotification.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 20/09/2023.
//

import SwiftUI

struct LocalPushNotification: View {
    var pushNotification = NotificationManager()
    var body: some View {
        VStack {
            Button(action: {
                pushNotification.scheduleNotification(at: Date(), ofType: .time, withTimeInterval: 1,titled: "Prismm", andBody: "Swift dep chai")
            }) {
                Text("Send Notification")
            }
            
            Button(action: {
                pushNotification.requestNotificationPermission()
            }) {
                Text("Request Permission")
            }
        }
    }
}

struct LocalPushNotification_Previews: PreviewProvider {
    static var previews: some View {
        LocalPushNotification()
    }
}
