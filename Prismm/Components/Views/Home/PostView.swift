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
    var body: some View {
        GeometryReader {reader in
            VStack {
                //Post info.
                HStack {
                    Image("ProfileImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(reader.size.width, reader.size.height) * 0.12) // Set the desired width and height for your circular image
                        .clipShape(Circle()) // Apply a circular clipping shape
                        .padding(.leading, reader.size.width * 0.001)
                    
                    VStack (alignment: .leading, spacing: reader.size.height * 0.01) {
                        Text("FELIX")
                            .font(Font.system(size: 14, weight: .semibold))
                        
                        Text("8th September ")
                            .font(Font.system(size: 14, weight: .medium))
                            .opacity(0.3)
                    }
                    
                    // In building
                    Spacer()
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: reader.size.width * 0.04, height: reader.size.height * 0.01)
                        .padding(.trailing, reader.size.width * 0.02)
                }
                .padding(.horizontal, reader.size.width * 0.02)
                
                
                //Caption
                HStack {
                    Text("New to the app")
                    Spacer()
                }.padding(.horizontal, reader.size.width * 0.02)
                    .padding(.vertical, reader.size.height * 0.008)
                
                
                //Image.
                Image("ProfileImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: reader.size.width)
                    .clipped()
                    .padding(.bottom, reader.size.height * 0.01)
                
                //Operations menu.
                HStack (spacing: reader.size.width * 0.08) {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                            .resizable()
                            .frame(width: reader.size.width * 0.06, height: reader.size.height * 0.03)
                        
                        Text("102")
                            .font(Font.system(size: reader.size.width * 0.05, weight: .medium))
                            .opacity(0.6)
                    }
                    .padding(.leading, reader.size.width * 0.04)
                    
                    HStack {
                        Image(systemName: "bubble.right")
                            .resizable()
                            .frame(width: reader.size.width * 0.06, height: reader.size.height * 0.03)
                        
                        Text("15")
                            .font(Font.system(size: reader.size.width * 0.05, weight: .medium))
                            .opacity(0.6)
                    }
                    .padding(.leading, reader.size.width * 0.04)
    
                    Spacer()
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: reader.size.width * 0.06, height: reader.size.height * 0.03)
                        .padding(.trailing, reader.size.width * 0.04)
                }.padding(.bottom, reader.size.height * 0.015)
                
                HStack{
                    //            user image
                    Image("ProfileImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(reader.size.width, reader.size.height) * 0.1) // Set the desired width and height for your circular image
                        .clipShape(Circle()) // Apply a circular clipping shape      input area
                    TextField("Comment..", text: $commentContent)
                        .font(.system(size: reader.size.width * 0.04))
                        .padding(.horizontal, 10) // Add horizontal padding to the text field
                                .background(
                                    RoundedRectangle(cornerRadius: 15) // Adjust the corner radius as needed
                                        .fill(Color.gray.opacity(0.1)) // Customize the background color
                                        .frame(height: reader.size.height * 0.05)
                                )
                }
                .padding(.horizontal, reader.size.width * 0.03)
                
                VStack{
                    Rectangle()
                        .frame(height: reader.size.height * 0.002)
                        .foregroundColor(Color.gray)
                }
                .padding(.vertical, reader.size.height * 0.01)
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
