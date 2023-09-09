//
//  PostGridView.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 09/09/2023.
//

import SwiftUI

struct PostGridView: View {
    var images: [String] = ["testAvt","testAvt1","testAvt2","testAvt3","testAvt4","testAvt5","testAvt6","testAvt7","testAvt8","testAvt9"]
    var columnsGrid: [GridItem] = [GridItem(.flexible(),spacing: 1),GridItem(.flexible(),spacing: 1),GridItem(.flexible(),spacing: 1)]
    var body: some View {
        LazyVGrid(columns: columnsGrid,spacing: 1) {
            ForEach(images, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: (UIScreen.main.bounds.width/3)-1,height: (UIScreen.main.bounds.width/3)-1)
            }
        }
    }
}

struct PostGridView_Previews: PreviewProvider {
    static var previews: some View {
        PostGridView()
        
        PostGridView().previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
