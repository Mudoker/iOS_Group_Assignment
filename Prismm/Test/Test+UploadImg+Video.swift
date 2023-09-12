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
                ForEach(uploadVM.fetched_images) { media in
                    Image(media.mediaUrl)
//                    if let mediaUrl = URL(string: media.mediaUrl) {
//                        let playerItem = AVPlayerItem(url: mediaUrl)
//                        let player = AVPlayer(playerItem: playerItem)
//
//                        VideoPlayer(player: player)
//                            .frame(height: 200)
//                            .onAppear {
//                                // Optionally, you can play the video when it appears on the screen.
//                                player.play()
//                            }
//                    } else {
//                        // Handle the case where the media URL is invalid or empty.
//                        Text("Invalid media URL")
//                    }
//                    VideoPlayer(player: AVPlayer(url: URL(string: media.mediaUrl)!))
//                        .frame(height: 200)
    //                    VideoPlayer (player: AVPlayer(url: URL(string: media.mediaUrl) ?? URL(fileURLWithPath: "")))
                }
            }
            .refreshable {
                Task {
                    try await uploadVM.fetchMedia()
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
