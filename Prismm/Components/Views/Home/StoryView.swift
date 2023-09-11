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
    
    var body: some View {
        GeometryReader {reader in
            //Stories
            VStack {
                Image("test")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle()) // Apply a circular clipping shape
                    .overlay(Circle().stroke(LinearGradient( gradient: gradient, startPoint: .bottomLeading, endPoint: .topTrailing) , style: StrokeStyle(lineWidth: 3, lineCap: .round)))
                
                Text("IamFelixVietNguyen")
                    .truncationMode(.tail)
                    .font(.caption2)
                    .lineLimit(1)
                    //.frame(width: reader.size.width, height: reader.size.height)
            }
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
