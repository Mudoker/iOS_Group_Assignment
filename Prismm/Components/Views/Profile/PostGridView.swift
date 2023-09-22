/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Apple Men
  Doan Huu Quoc (s3927776)
  Tran Vu Quang Anh (s3916566)
  Nguyen Dinh Viet (s3927291)
  Nguyen The Bao Ngoc (s3924436)

  Created  date: 09/09/2023
  Last modified: 10/09/2023
  Acknowledgement: None
*/

import SwiftUI
import Kingfisher
import AVKit

struct PostGridView: View {
    
    @Binding var currentUser:User
    @Binding var userSetting:UserSetting
    
    @ObservedObject var profileVM: ProfileViewModel
    
    var columnsGrid: [GridItem] = [GridItem(.fixed((UIScreen.main.bounds.width/3) - 2), spacing: 2), GridItem(.fixed((UIScreen.main.bounds.width/3) - 3), spacing: 2), GridItem(.fixed((UIScreen.main.bounds.width/3) - 2), spacing: 2)]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columnsGrid, spacing: 2 ) {
                ForEach(profileVM.posts) { post in
                    if let mediaURL = URL(string: post.mediaURL ?? "") {
                        if let mimeType = post.mediaMimeType {
                            if !mimeType.hasPrefix("image") {
                                // Handle video
                                let playerItem = AVPlayerItem(url: mediaURL)
                                let player = AVPlayer(playerItem: playerItem)
                                
                                VideoPlayer(player: player)
                                    .scaledToFill()
                                    .frame(width: (UIScreen.main.bounds.width/3) - 2 , height: (UIScreen.main.bounds.width/3) - 2)

                            } else {
                                // Handle images using Kingfisher
                                KFImage(mediaURL)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (UIScreen.main.bounds.width/3) - 2 , height: (UIScreen.main.bounds.width/3) - 2)
                                    .background(Color.gray)
                                    .clipShape(Rectangle())
                            }
                        } else {
                            // Handle the case where the mimeType is nil
                            Text("Invalid MIME type")
                        }
                    } else {
                        // Handle the case where the media URL is invalid or empty.
                        Image(userSetting.darkModeEnabled ? "logodark" : "logolight")
                    }
                }
            }
        }

    }
}
