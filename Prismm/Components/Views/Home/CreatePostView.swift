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

  Created  date: 14/09/2023
  Last modified: 16/09/2023
  Acknowledgement: None
*/

import SwiftUI

struct CreatePostView: View {

    @State private var searchText = ""
    @State private var users = ["mudoker7603", "user123", "sampleUser", "testUser", "john_doe", "jane_doe", "user007", "newUser", "oldUser", "demoUser"]
    
    @Binding var isNewPost: Bool
    @Binding var isDarkMode: Bool
    
    @ObservedObject var homeViewModel = HomeViewModel()
    
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
                                homeViewModel.isShowTagListIpad.toggle()
                            } else {
                                homeViewModel.isShowTagListIphone.toggle()

                            }
                        }) {
                            HStack {
                                Image(systemName: "plus.app")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: proxy.size.width/24)
                                    .foregroundColor(!isDarkMode ? Constants.lightThemeColor : Constants.darkThemeColor)
                                
                                if homeViewModel.tagList.isEmpty {
                                    Text("Notify your friend")
                                        .font(.callout)
                                        .foregroundColor(!isDarkMode ? Constants.lightThemeColor : Constants.darkThemeColor)
                                        .frame(height: proxy.size.height/40)
                                } else {
                                    // Horizontal scroll view
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        ScrollViewReader { scrollProxy in
                                            HStack(spacing: proxy.size.width/30) {
                                                ForEach(homeViewModel.tagList, id: \.self) { user in
                                                    HStack {
                                                        Text(user)
                                                            .foregroundColor(.white)
                                                            .font(.callout)
                                                        
                                                        Button(action: {
                                                            // Remove the user from the tagList
                                                            if let index = homeViewModel.tagList.firstIndex(of: user) {
                                                                homeViewModel.tagList.remove(at: index)
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
                                                .onChange(of: homeViewModel.tagList.count) { _ in
                                                    withAnimation {
                                                        // automatically scroll to end
                                                        scrollProxy.scrollTo(homeViewModel.tagList.last, anchor: .trailing)
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
                        .frame(height: proxy.size.height/3.2)
                    
                    TextField("", text: $homeViewModel.postCaption, prompt:  Text("Share your updates...").foregroundColor(isDarkMode ? .white.opacity(0.5) : .black.opacity(0.5))
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
                        try await homeViewModel.createPost(owner: "3WBgDcMgEQfodIbaXWTBHvtjYCl2", postCaption: homeViewModel.postCaption, mediaURL: "", mimeType: "")
                        isNewPost = false
                    }
                    
                    homeViewModel.isPost.toggle()
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
            .fullScreenCover(isPresented: $homeViewModel.isShowTagListIphone) {
                VStack {
                    HStack (alignment: .firstTextBaseline) {
                        Text("Tag a friend")
                            .bold()
                            .font(.title)
                            .padding(.top)
                            .padding(.top)

                        Spacer()
                        
                        Button(action: {
                            homeViewModel.isShowTagListIphone = false // Close the sheet
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
                                    if !homeViewModel.tagList.contains(user) {
                                        homeViewModel.tagList.append(user)
                                    }
                                    homeViewModel.isShowTagListIphone.toggle()
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
            .sheet(isPresented: $homeViewModel.isShowTagListIpad) {
                VStack {
                    HStack (alignment: .firstTextBaseline) {
                        Text("Tag a friend")
                            .bold()
                            .font(.title)
                            .padding(.top)
                            .padding(.top)

                        Spacer()
                        
                        Button(action: {
                            homeViewModel.isShowTagListIpad = false // Close the sheet
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
                                    if !homeViewModel.tagList.contains(user) {
                                        homeViewModel.tagList.append(user)
                                    }
                                    homeViewModel.isShowTagListIpad.toggle()
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
        CreatePostView(isNewPost: .constant(true), isDarkMode: .constant(false))
    }
}
