//
//  Login.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI

struct Login: View {
    // Responsive
    @State var titleFont: CGFloat = 40
    @State var logoImageSize: CGFloat = 0
    @State var captionFont: Font = .caption
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .leading) {
                // Title
                Text ("Log in")
                    .font(.system(size: titleFont))
                    .bold()
                
                Text ("Please log in to continue")
                    .font(captionFont)
                    .opacity(0.7)
                // Logo
                HStack {
                    Spacer()
                    
                    Image("applogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: proxy.size.width/1.5)
                    
                    Spacer()
                }
                
                CustomTextField(text: "Username")
            }
            .padding(.horizontal)
        }
        .background(.gray.opacity(0.2))
//        .background(.black)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
