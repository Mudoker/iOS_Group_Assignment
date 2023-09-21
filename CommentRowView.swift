//
//  CommentRowView.swift
//  Prismm
//
//  Created by Ngoc Nguyen The Bao on 21/09/2023.
//

import SwiftUI

struct CommentRowView: View {
    var commentor: User?
    var comment: Com
    @ObservedObject var homeViewModel : HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack (alignment: .firstTextBaseline) {
                Text(commentor?.username ?? "Blank") // User Name
                    .font(Font.system(size: homeViewModel.usernameFont, weight: .medium))
                    .bold()
                
                Text(formatTimeDifference(from: comment.creationDate))
                    .font(Font.system(size: homeViewModel.timeFont, weight: .medium))
                    .opacity(0.3)
            }
            Text(comment.content) // Message
        }
    }
}

struct CommentRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommentRowView()
    }
}
