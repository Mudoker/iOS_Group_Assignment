//
//  CreatePostView.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 14/09/2023.
//

import SwiftUI

struct CreatePostView: View {
    @State var tagList: [String] = []
    @State var isShowTagListIphone = false
    @State var isShowTagListIpad = false
    @State var postCaption = ""
    @State var isDarkMode = false
    @State var isPost = false
    @State private var searchText = ""
    @State private var users = ["mudoker7603", "user123", "sampleUser", "testUser", "john_doe", "jane_doe", "user007", "newUser", "oldUser", "demoUser"]
    @Binding var isNewPost: Bool
    @ObservedObject var uploadVM = UploadPostViewModel()
    var filteredUsers: [String] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack {
                    Text("Create new post")
                        .bold()
                        .font(.title)
                        .padding(.vertical)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isNewPost = false // Close the sheet
                        }) {
                            Image(systemName: "xmark.circle.fill") // You can use any close button icon
                                .font(.title)
                        }
                    }
                }
                
                Divider()
                    .overlay(isDarkMode ? .white : .gray)

                HStack (alignment: .top) {
                    Image("testAvt")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width/7, height: proxy.size.width/7)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text("mudoker_7603")
                            .bold()
                            .font(.title3)
                        
                        Button(action: {
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                isShowTagListIpad.toggle()
                            } else {
                                isShowTagListIphone.toggle()

                            }
                        }) {
                            HStack {
                                Image(systemName: "plus.app")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: proxy.size.width/24)
                                    .foregroundColor(!isDarkMode ? Constants.lightThemeColor : Constants.darkThemeColor)
                                
                                if tagList.isEmpty {
                                    Text("Notify your friend")
                                        .font(.callout)
                                        .foregroundColor(!isDarkMode ? Constants.lightThemeColor : Constants.darkThemeColor)
                                        .frame(height: proxy.size.height/40)
                                } else {
                                    // Horizontal scroll view
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        ScrollViewReader { scrollProxy in
                                            HStack(spacing: proxy.size.width/30) {
                                                ForEach(tagList, id: \.self) { user in
                                                    HStack {
                                                        Text(user)
                                                            .foregroundColor(.white)
                                                            .font(.callout)
                                                        
                                                        Button(action: {
                                                            // Remove the user from the tagList
                                                            if let index = tagList.firstIndex(of: user) {
                                                                tagList.remove(at: index)
                                                            }
                                                        }) {
                                                            Image(systemName: "x.circle.fill")
                                                                .font(.callout)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                    .padding(.horizontal, 8)
                                                    .padding(.leading, 2)
                                                    .padding(.vertical, 4.2)
                                                    .background(Capsule()
                                                        .foregroundColor(isDarkMode ? Constants.darkThemeColor : Constants.lightThemeColor))
                                                    .id(user)
                                                }
                                                .onChange(of: tagList.count) { _ in
                                                    withAnimation {
                                                        // automatically scroll to end
                                                        scrollProxy.scrollTo(tagList.last, anchor: .trailing)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .frame(height: proxy.size.height/40)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top)
                                
                ZStack (alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: proxy.size.width/40)
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: isDarkMode ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1.5)
                        .frame(height: proxy.size.height/2.5)
                    
                    TextField("", text: $postCaption, prompt:  Text("Share your updates...").foregroundColor(isDarkMode ? .white.opacity(0.5) : .black.opacity(0.5))
                        .font(.title3)
                    )
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .padding()
                }
                .padding(.vertical)
                
                
                HStack {
                    Text("Post Media")
                        .bold()
                        .font(.title3)
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: proxy.size.width/12)
                            .foregroundColor(.green)
                    }
                    .padding(.trailing, 8)
                    
                    Button(action: {}) {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: proxy.size.width/12)
                            .foregroundColor(!isDarkMode ? Constants.lightThemeColor : Constants.darkThemeColor)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: proxy.size.width/40)
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: isDarkMode ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1.5)
                )
                .padding(.bottom)

                
                VStack(alignment: .leading) {
                    Text ("No Sensitive, Explicit, or Harmful Content")
                        .bold()
                    
                    Text ("Please refrain from uploading sensitive, explicit, or harmful content, as well as hate speech or harassment.")
                        .opacity(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: proxy.size.width/40)
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: isDarkMode ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1.5)
                )
                
                Button(action: {
                    Task {
                        try await uploadVM.createPost(owner: "3WBgDcMgEQfodIbaXWTBHvtjYCl2", postCaption: postCaption, mediaURL: "", mimeType: "")
                        isNewPost = false
                    }
                    
                    isPost.toggle()
                }) {
                    RoundedRectangle(cornerRadius: proxy.size.width/40)
                        .frame(height: proxy.size.width/7)
                        .foregroundColor(!isDarkMode ? Constants.lightThemeColor : Constants.darkThemeColor)
                        .overlay(
                            HStack {
                                
                                Text("Post")
                                    .font(.title3)
                                    .bold()
                                
                                Image(systemName: "paperplane.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: proxy.size.width/18)
                                
                            }
                                .foregroundColor(.white)
                        )
                }
                .padding(.top)
                .padding(.top)
                Spacer()
            }
            .padding(.horizontal)
            .fullScreenCover(isPresented: $isShowTagListIphone) {
                VStack {
                    HStack (alignment: .firstTextBaseline) {
                        Text("Tag a friend")
                            .bold()
                            .font(.title)
                            .padding(.top)
                            .padding(.top)

                        Spacer()
                        
                        Button(action: {
                            isShowTagListIphone = false // Close the sheet
                        }) {
                            Image(systemName: "xmark.circle.fill") // You can use any close button icon
                                .font(.title)
                        }
                        
                    }
                    .padding([.top, .horizontal])
                    
                    
                    VStack {
                        ZStack (alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: proxy.size.width/40)
                                .stroke(LinearGradient(
                                    gradient: Gradient(colors: isDarkMode ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ), lineWidth: 1.5)
                                .frame(height: proxy.size.height/15)
                            
                            TextField("", text: $searchText, prompt:  Text("Search a friend...").foregroundColor(isDarkMode ? .white.opacity(0.5) : .black.opacity(0.5))
                                .font(.title3)
                                
                            )
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .padding()
                        }
                        .padding([.horizontal, .bottom])
                        
                        ScrollView {
                            ForEach(filteredUsers, id: \.self) {user in
                                Button(action: {
                                    if !tagList.contains(user) {
                                        tagList.append(user)
                                    }
                                    isShowTagListIphone.toggle()
                                }) {
                                    HStack {
                                        Image("testAvt")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: proxy.size.width/7, height: proxy.size.width/7)
                                            .clipShape(Circle())
                                        
                                        Text(user)
                                        Spacer()
                                    }
                                    .padding(.horizontal)

                                }
                            }
                        }
                        
                    }
                }
                .foregroundColor(isDarkMode ? .white : .black)
                .background(!isDarkMode ? .white : .black)
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled)
            }
            .sheet(isPresented: $isShowTagListIpad) {
                VStack {
                    HStack (alignment: .firstTextBaseline) {
                        Text("Tag a friend")
                            .bold()
                            .font(.title)
                            .padding(.top)
                            .padding(.top)

                        Spacer()
                        
                        Button(action: {
                            isShowTagListIpad = false // Close the sheet
                        }) {
                            Image(systemName: "xmark.circle.fill") // You can use any close button icon
                                .font(.title)
                        }
                        
                    }
                    .padding([.top, .horizontal])
                    
                    
                    VStack {
                        ZStack (alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: proxy.size.width/40)
                                .stroke(LinearGradient(
                                    gradient: Gradient(colors: isDarkMode ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ), lineWidth: 1.5)
                                .frame(height: proxy.size.height/15)
                            
                            TextField("", text: $searchText, prompt:  Text("Search a friend...").foregroundColor(isDarkMode ? .white.opacity(0.5) : .black.opacity(0.5))
                                .font(.title3)
                                
                            )
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .padding()
                        }
                        .padding([.horizontal, .bottom])
                        
                        ScrollView {
                            ForEach(filteredUsers, id: \.self) {user in
                                Button(action: {
                                    if !tagList.contains(user) {
                                        tagList.append(user)
                                    }
                                    isShowTagListIpad.toggle()
                                }) {
                                    HStack {
                                        Image("testAvt")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: proxy.size.width/7, height: proxy.size.width/7)
                                            .clipShape(Circle())
                                        
                                        Text(user)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                    }
                }
                .padding(.horizontal)
                .foregroundColor(isDarkMode ? .white : .black)
                .background(!isDarkMode ? .white : .black)
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled)
            }
        }
        .foregroundColor(isDarkMode ? .white : .black)
        .background(!isDarkMode ? .white : .black)
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(isNewPost: .constant(true))
    }
}
