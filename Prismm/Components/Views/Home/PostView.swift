//
//  Post.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 08/09/2023.
//

import Foundation
import SwiftUI
import AVKit

struct PostView: View {
    @State private var commentContent = ""
    let post: Post
    
    // View model
    @ObservedObject var homeViewModel = HomeViewModel()
    @ObservedObject var viewModel = UploadPostViewModel()
    
    var body: some View {
        GeometryReader {proxy in
            VStack {
                //Post info.
                HStack {
                    if let mediaURL = URL(string: post.mediaURL ?? "") {
                        if let mimeType = post.mimeType {
                            if mimeType.hasPrefix("image") {
                                AsyncImage(url: mediaURL) { phase in
                                    switch phase {
                                    case .empty:
                                        // Placeholder while loading
                                        ProgressView()
                                    case .success(let image):
                                        // Image loaded successfully
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: homeViewModel.profileImageSize, height: homeViewModel.profileImageSize ) // Set the desired width and height for your circular image
                                            .clipShape(Circle()) // Apply a circular clipping shape
                                        
                                    case .failure(_):
                                        // Handle error, e.g., display a placeholder or error message
                                        Text("Image loading failed")
                                    @unknown default:
                                        // Handle other states if needed
                                        Text("Unknown state")
                                    }
                                }
                            } else {
                                // Handle image
                                Text("Video detected!")
                            }
                        } else {
                            // Handle the case where the mimeType is nil
                            Text("Invalid MIME type")
                        }
                    } else {
                        // Handle the case where the media URL is invalid or empty.
                        Text("Invalid media URL")
                    }
                        
                    
                    VStack (alignment: .leading, spacing: proxy.size.height * 0.01) {
                        if let user = post.user {
                            Text(user.username)
                                .font(Font.system(size: homeViewModel.usernameFont, weight: .semibold))
                        }
                        
                        Text("8th September ")
                            .font(Font.system(size: homeViewModel.usernameFont, weight: .medium))
                            .opacity(0.3)
                    }
                    
                    // In building
                    Spacer()
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: homeViewModel.seeMoreButtonSize)
                        .padding(.trailing, proxy.size.width * 0.02)
                }
                .padding(.horizontal)
                
                
                //Caption
                HStack {
                    Text(post.postCaption)
                        .font(homeViewModel.captionFont)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, proxy.size.width * 0.008)
                
                
                //Image.
                if let mediaURL = URL(string: post.mediaURL ?? "") {
                    if let mimeType = post.mimeType {
                        if !mimeType.hasPrefix("image") {
                            // Handle video
                            let playerItem = AVPlayerItem(url: mediaURL)
                            let player = AVPlayer(playerItem: playerItem)
                            
                            VideoPlayer(player: player)
                                .frame(width: proxy.size.width)
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
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: proxy.size.width)
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
                    
                
                //Operations menu.
                HStack (spacing: proxy.size.width * 0.08) {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: homeViewModel.postStatsImageSize)
                        
                        Text("\(post.likers.count)")
                            .font(Font.system(size: homeViewModel.postStatsFontSize, weight: .light))
                            .opacity(0.6)
                    }
                    .padding(.leading, proxy.size.width * 0.04)
                    
                    HStack {
                        Image(systemName: "bubble.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: homeViewModel.postStatsImageSize)

                        Text("15")
                            .font(Font.system(size: homeViewModel.postStatsFontSize, weight: .light))
                            .opacity(0.6)
                    }
    
                    Spacer()
                    
                    Image(systemName: "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: homeViewModel.postStatsImageSize)
                        .padding(.trailing)

                }
                .padding(.vertical)
                
                HStack{
                    if let mediaURL = URL(string: post.mediaURL ?? "") {
                        if let mimeType = post.mimeType {
                            if mimeType.hasPrefix("image") {
                                AsyncImage(url: mediaURL) { phase in
                                    switch phase {
                                    case .empty:
                                        // Placeholder while loading
                                        ProgressView()
                                    case .success(let image):
                                        // Image loaded successfully
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: homeViewModel.commentProfileImage, height: homeViewModel.commentProfileImage ) // Set the desired width and height for your circular image
                                            .clipShape(Circle()) // Apply a circular clipping shape      input area
                                        
                                    case .failure(_):
                                        // Handle error, e.g., display a placeholder or error message
                                        Text("Image loading failed")
                                    @unknown default:
                                        // Handle other states if needed
                                        Text("Unknown state")
                                    }
                                }
                            } else {
                                // Handle image
                                Text("Video detected!")
                            }
                        } else {
                            // Handle the case where the mimeType is nil
                            Text("Invalid MIME type")
                        }
                    } else {
                        // Handle the case where the media URL is invalid or empty.
                        Text("Invalid media URL")
                    }
                    
                
                TextField("Comment..", text: $commentContent)
                    .font(homeViewModel.commentTextFiledFont)
                    .padding(.horizontal) // Add horizontal padding to the text field
                            .background(
                                RoundedRectangle(cornerRadius: homeViewModel.commentTextFieldRoundedCorner) // Adjust the corner radius as needed
                                    .fill(Color.gray.opacity(0.1)) // Customize the background color
                                    .frame(height: homeViewModel.commentTextFieldSizeHeight)
                            )
                }
                .padding(.horizontal)
            }
        }
    }
}

//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        Post
//    }
//}
