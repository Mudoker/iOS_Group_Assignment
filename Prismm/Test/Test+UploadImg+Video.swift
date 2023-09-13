//
//  Test+UploadImg+Video.swift
//  Prismm
//
//  Created by quoc on 12/09/2023.
//

import SwiftUI
import PhotosUI
import AVKit

struct Test_UploadImg_Video: View {
    @StateObject var uploadVM = UploadPostViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(uploadVM.fetched_post) { post in
//                    Text(post.postCaption)
                    if let user = post.user {
                        Text(user.username)
                    }

                    if let mediaURL = URL(string: post.mediaURL ?? "") {
                        if let mimeType = post.mimeType {
                            if !mimeType.hasPrefix("image") {
                                // Handle video
                                let playerItem = AVPlayerItem(url: mediaURL)
                                let player = AVPlayer(playerItem: playerItem)
                                
                                VideoPlayer(player: player)
                                    .frame(height: 200)
                                    .onAppear {
                                        // Optionally, you can play the video when it appears on the screen.
                                        player.play()
                                    }
                            } else {
                                // Handle image
                                AsyncImage(url: mediaURL) { phase in
                                    switch phase {
                                    case .empty:
                                        // Placeholder while loading
                                        ProgressView()
                                    case .success(let image):
                                        // Image loaded successfully
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 200)
                                    case .failure(_):
                                        // Handle error, e.g., display a placeholder or error message
                                        Text("Image loading failed")
                                    @unknown default:
                                        // Handle other states if needed
                                        Text("Unknown state")
                                    }
                                }
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
            .refreshable {
                Task {
                    try await uploadVM.fetchPost()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(selection: $uploadVM.selectedMedia, matching: .any(of: [.videos, .images, .screenRecordings, .timelapseVideos, .screenshots])){
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct Test_UploadImg_Video_Previews: PreviewProvider {
    static var previews: some View {
        Test_UploadImg_Video()
    }
}
