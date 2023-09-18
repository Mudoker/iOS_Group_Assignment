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

  Created  date: 08/09/2023
  Last modified: 13/09/2023
  Acknowledgement: None
*/

import Foundation
import SwiftUI

struct StoryView: View {
    //let story: Story
    
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        GeometryReader {reader in
            //Stories
            VStack {
                Image("testAvt")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle()) // Apply a circular clipping shape
                    .overlay(Circle().stroke(LinearGradient( gradient: Constants.storyGradientBorder, startPoint: .bottomLeading, endPoint: .topTrailing) , style: StrokeStyle(lineWidth: 3, lineCap: .round)))
                
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
