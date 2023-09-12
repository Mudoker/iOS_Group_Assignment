//
//  Story.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 08/09/2023.
//

import Foundation
import SwiftUI

struct StoryView: View {
    //let story: Story
    var gradient = Gradient(colors: [.yellow, .red, .purple, .orange, .pink, .red])
    
    @ObservedObject var homeViewModel = HomeViewModel()
    @Binding var bundle : StoryBuddle
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var storyData : StoryViewModel

    var body: some View {
        GeometryReader {reader in
            //Stories
            VStack {
                Image(bundle.progfileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle()) // Apply a circular clipping shape
                    // progress bar
                    .padding(2)
                    .background(scheme == .dark ? .black : .white, in: Circle())
                    .padding(2)
                    .background(
                        LinearGradient( colors : [
                            .red,
                                .orange,
                                .red,
                            .orange
                        ],startPoint: .top, endPoint: .bottom)
                        .clipShape(Circle())
                        .opacity(bundle.isSeen ? 0 : 1)
                    )
                    .onTapGesture {
                        withAnimation{
                            bundle.isSeen = true
                            storyData.currentStory = bundle.id
                            storyData.showStory = true
                        }
                    }
                    
                
                Text("IamFelixVietNguyen")
                    .truncationMode(.tail)
                    .font(.caption2)
                    .lineLimit(1)
                    //.frame(width: reader.size.width, height: reader.size.height)
            }
        }
    }
}

//
