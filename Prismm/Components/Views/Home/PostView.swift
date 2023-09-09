//
//  Post.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 08/09/2023.
//

import Foundation
import SwiftUI

struct PostView: View {
    @State private var commentContent = ""
    
    // View model
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        GeometryReader {proxy in
            VStack {
                //Post info.
                HStack {
                    Image("test")
                        .resizable()
                        .scaledToFit()
                        .frame(width: homeViewModel.profileImageSize) // Set the desired width and height for your circular image
                        .clipShape(Circle()) // Apply a circular clipping shape
                    
                    VStack (alignment: .leading, spacing: proxy.size.height * 0.01) {
                        Text("FELIX")
                            .font(Font.system(size: homeViewModel.usernameFont, weight: .semibold))
                        
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
                    Text("New to the app")
                        .font(homeViewModel.captionFont)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, proxy.size.width * 0.008)
                
                
                //Image.
                Image("test")
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width)
                
                //Operations menu.
                HStack (spacing: proxy.size.width * 0.08) {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: homeViewModel.postStatsImageSize)
                        
                        Text("102")
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
                    //user image
                    Image("test")
                        .resizable()
                        .scaledToFit()
                        .frame(width: homeViewModel.commentProfileImage) // Set the desired width and height for your circular image
                        .clipShape(Circle()) // Apply a circular clipping shape      input area
                    
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
                
                VStack{
                    Rectangle()
                        .frame(height: proxy.size.height * 0.0005)
                        .foregroundColor(Color.gray.opacity(0.5))
                }
                .padding(.vertical)
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
