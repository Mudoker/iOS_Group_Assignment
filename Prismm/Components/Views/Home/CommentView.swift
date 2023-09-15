//
//  CommentView.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 14/09/2023.
//

import SwiftUI

struct CommentView: View {
    let comments = [
        ("User1", "1d", "Hello world!"),
        ("User2", "2d", "This is a test."),
        ("User3", "3d", "Lorem ipsum dolor sit amet."),
        ("Viet", "4d", "SwiftUI L!"),
        ("User5", "5d", "Building apps is fun."),
        ("User6", "6d", "Explore SwiftUI."),
        ("User7", "7d", "Learn new things."),
        ("User8", "8d", "Creating cool designs."),
        ("User9", "9d", "Welcome to SwiftUI."),
        ("User10", "10d", "This is the last item.")
    ]
    @State var comment = ""
    @State var isDarkMode = false
    @State var isAddingComment = false
    @State var selectedFilter = "Newest"
    @Binding var isShowComment: Bool
    let emojis = ["👍", "❤️", "😍", "🤣", "😯", "😭", "😡", "👽", "💩", "💀"]
    
    var body: some View {
        GeometryReader { proxy in
            VStack (spacing: 0) {
                ZStack(alignment: .centerFirstTextBaseline) {
                    Text("Comment")
                        .font(.title2)
                        .padding(.bottom)
                        .bold()
                    
                    HStack {
                        Menu {
                            Picker(selection: $selectedFilter, label: Text("Please choose a sorting option")) {
                                Text("Newest").tag("Newest")
                                Text("Oldest").tag("Oldest")
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.title)
                        }
                        Spacer()
                        
                        Button(action: {
                            isShowComment = false // Close the sheet
                        }) {
                            Image(systemName: "xmark.circle.fill") // You can use any close button icon
                                .font(.title)
                        }
                    }
                    .padding(.horizontal)
                }
                
                ScrollView(showsIndicators: false) {
                    ForEach(comments, id: \.0) { data in
                        HStack {
                            Image("testAvt")
                                .resizable()
                                .frame(width: proxy.size.width/8, height: proxy.size.width/8)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(data.0) // User Name
                                        .bold()
                                    Text(data.1) // Time
                                }
                                
                                Text(data.2) // Message
                            }
                            
                            Spacer()
                        }
                        .padding()
                    }
                }
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(emojis, id: \.self) { emoji in
                                Button(action: {
                                    comment += emoji
                                }) {
                                    Text(emoji)
                                        .font(.largeTitle)
                                        .padding(8)
                                        .background(Circle().fill(isDarkMode ? Color.gray.opacity(0.3) : Color.white))
                                }
                                .padding([.horizontal])
                                .padding(.top, 8)
                            }
                        }
                    }
                    
                    
                    HStack {
                        Image("testAvt")
                            .resizable()
                            .frame(width: proxy.size.width/8, height: proxy.size.width/8)
                            .clipShape(Circle())
                        
                        TextField("", text: $comment, prompt:  Text("Leave a comment...").foregroundColor(isDarkMode ? .white.opacity(0.5) : .black.opacity(0.5))
                            .font(.title3)
                        )
                        .padding()
                        .background(
                            Capsule()
                                .fill(isDarkMode ? Color.gray.opacity(0.3) : Color.white)
                        )
                        
                        Button(action: {comment = ""}) {
                            Circle()
                                .fill(isDarkMode ? .gray.opacity(0.3) : .white)
                                .frame(width: proxy.size.width/8)
                                .overlay (
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: proxy.size.width/16)
                                        .foregroundColor(isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor)
                                )
                        }
                    }
                    .padding()
                    
                }
                .background(.gray.opacity(0.1))
                
            }
            
            .padding(.vertical)
        }
        .foregroundColor(!isDarkMode ? .black : .white)
        .background(isDarkMode ? .black : .white)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(isShowComment: .constant(true))
    }
}
