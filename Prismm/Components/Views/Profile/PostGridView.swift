//
//  PostGridView.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 09/09/2023.
//

import SwiftUI
import Kingfisher
import AVKit
struct PostGridView: View {
//    var images: [String] = ["testAvt","fb","mail","testAvt3","testAvt4","testAvt5","testAvt6","testAvt7","testAvt8","testAvt9"]
    @StateObject var profileVM : ProfileViewModel
    //@StateObject var authVM : AuthenticationViewModel
    
    
    var columnsGrid: [GridItem] = [GridItem(.flexible(),spacing: 1),GridItem(.flexible(),spacing: 1),GridItem(.flexible(),spacing: 1)]
    var body: some View {
        LazyVGrid(columns: columnsGrid,spacing: 1) {
            ForEach(profileVM.posts) {post in
                if let mediaURL = URL(string: post.mediaURL ?? "") {
                    if let mimeType = post.mimeType {
                        if !mimeType.hasPrefix("image") {
                            // Handle video
                            let playerItem = AVPlayerItem(url: mediaURL)
                            let player = AVPlayer(playerItem: playerItem)
                            
                            VideoPlayer(player: player)
                                .frame(width: UIScreen.main.bounds.width)
                                .frame(minHeight: UIScreen.main.bounds.height * 0.4)
                                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                                .onAppear {
                                    // Optionally, you can play the video when it appears on the screen.
                                    player.play()
                                }
                        } else {
                            KFImage(mediaURL)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width)
                                .frame(minHeight: UIScreen.main.bounds.height * 0.4)
                                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                                .background(Color.gray)
                                .clipShape(Rectangle())
                        }
                    } else {
                        // Handle the case where the mimeType is nil
                        Text("Invalid MIME type")
                    }
                } else {
                    // Handle the case where the media URL is invalid or empty.
                    Text("Invalid media URL")
                }
            }
        }
    }
}

