//
//  Test+Profile.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 14/09/2023.
//

import SwiftUI

struct Test_Profile: View {
    @StateObject var profileVM = ProfileViewModel()
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await profileVM.fetchUserPosts()
                } catch {
                    print("Error following user: \(error)")
                    // Handle the error as needed (e.g., display an error message to the user)
                }
            }
        }) {
            Text("Reload your post")
        }
    }
}

struct Test_Profile_Previews: PreviewProvider {
    static var previews: some View {
        Test_Profile()
    }
}
