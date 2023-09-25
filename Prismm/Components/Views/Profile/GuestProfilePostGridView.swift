import SwiftUI
import Kingfisher
import AVKit

struct GuestProfilePostGridView: View {
    // Control state
//    @Binding var currentUser: User
//    @Binding var userSetting: UserSetting
    @ObservedObject var profileVM: GuestProfileViewModel
    @EnvironmentObject var tabVM: TabBarViewModel
    

    var columnsGrid: [GridItem] = [
        GridItem(.fixed((UIScreen.main.bounds.width/3) - 2), spacing: 2),
        GridItem(.fixed((UIScreen.main.bounds.width/3) - 3), spacing: 2),
        GridItem(.fixed((UIScreen.main.bounds.width/3) - 2), spacing: 2)
    ]
    
    var body: some View {
            LazyVGrid(columns: columnsGrid, spacing: 2) {
                // Show posts of current user
                if profileVM.isShowAllUserPost == 1 {
                    ForEach(profileVM.userPosts) { post in
                        if let mediaURL = URL(string: post.mediaURL ?? "") {
                            if let mimeType = post.mediaMimeType {
                                if !mimeType.hasPrefix("image") {
                                    // Handle video
                                    let playerItem = AVPlayerItem(url: mediaURL)
                                    let player = AVPlayer(playerItem: playerItem)
                                    
                                    VideoPlayer(player: player)
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width/3) - 2, height: (UIScreen.main.bounds.width/3) - 2)
                                } else {
                                    // Handle images using Kingfisher
                                    KFImage(mediaURL)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width/3) - 2, height: (UIScreen.main.bounds.width/3) - 2)
                                        .background(Color.gray)
                                        .clipShape(Rectangle())
                                }
                            } else {
                                // Handle the case where the mimeType is nil
                                Text("Invalid MIME type")
                            }
                        } else {
                            // Handle the case where the media URL is invalid or empty.
                            Image(tabVM.userSetting.darkModeEnabled ? "logodark" : "logolight")
                        }
                    }
                } else {
                    ForEach(profileVM.unwrappedCurrentUserFavouritePost) { post in
                        if let mediaURL = URL(string: post.mediaURL ?? "") {
                            if let mimeType = post.mediaMimeType {
                                if !mimeType.hasPrefix("image") {
                                    // Handle video
                                    let playerItem = AVPlayerItem(url: mediaURL)
                                    let player = AVPlayer(playerItem: playerItem)
                                    
                                    VideoPlayer(player: player)
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width/3) - 2, height: (UIScreen.main.bounds.width/3) - 2)
                                } else {
                                    // Handle images using Kingfisher
                                    KFImage(mediaURL)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width/3) - 2, height: (UIScreen.main.bounds.width/3) - 2)
                                        .background(Color.gray)
                                        .clipShape(Rectangle())
                                }
                            } else {
                                // Handle the case where the mimeType is nil
                                Text("Invalid MIME type")
                            }
                        } else {
                            // Handle the case where the media URL is invalid or empty.
                            Image(tabVM.userSetting.darkModeEnabled ? "logodark" : "logolight")
                        }
                    }
                }
            }
        
    }
}
