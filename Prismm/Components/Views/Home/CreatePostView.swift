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
    @Binding var isDarkModeEnabled: Bool
    @Binding var proxySize : CGSize
    
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
                        .overlay{
                            
                        }
                    
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
                    .overlay(isDarkModeEnabled ? .white : .gray)
                
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
                                homeViewModel.isShowTagListOnIpad.toggle()
                            } else {
                                homeViewModel.isShowTagListOnIphone.toggle()
                                
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus.app")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: proxy.size.width/24)
                                    .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                
                                if homeViewModel.createNewPostTagList.isEmpty {
                                    Text("Notify your friend")
                                        .font(.callout)
                                        .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                        .frame(height: proxy.size.height/40)
                                } else {
                                    // Horizontal scroll view
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        ScrollViewReader { scrollProxy in
                                            HStack(spacing: proxy.size.width/30) {
                                                ForEach(homeViewModel.createNewPostTagList, id: \.self) { user in
                                                    HStack {
                                                        Text(user)
                                                            .foregroundColor(.white)
                                                            .font(.callout)
                                                        
                                                        Button(action: {
                                                            // Remove the user from the tagList
                                                            if let index = homeViewModel.createNewPostTagList.firstIndex(of: user) {
                                                                homeViewModel.createNewPostTagList.remove(at: index)
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
                                                        .foregroundColor(isDarkModeEnabled ? Constants.darkThemeColor : Constants.lightThemeColor))
                                                    .id(user)
                                                }
                                                .onChange(of: homeViewModel.createNewPostTagList.count) { _ in
                                                    withAnimation {
                                                        // automatically scroll to end
                                                        scrollProxy.scrollTo(homeViewModel.createNewPostTagList.last, anchor: .trailing)
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
                            gradient: Gradient(colors: isDarkModeEnabled ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1.5)
                        .frame(height: proxy.size.height/3.2)
                    
                    TextField("", text: $homeViewModel.createNewPostCaption, prompt:  Text("Share your updates...").foregroundColor(isDarkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.5))
                        .font(.title3)
                    )
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .padding()
                }
                .padding(.vertical)
                .padding(.bottom, UIDevice.current.userInterfaceIdiom == .phone ? 0 : 20)
                
                
                HStack {
                    Text("Post Media")
                        .bold()
                        .font(.title3)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: homeViewModel.iconCreatePostViewWidth, height: homeViewModel.iconCreatePostViewWidth)
                            .foregroundColor(.green)
                    }
                    .padding(.trailing, 8)
                    
                    Button(action: {}) {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:  homeViewModel.iconCreatePostViewWidth, height: homeViewModel.iconCreatePostViewWidth)
                            .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: proxy.size.width/40)
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: isDarkModeEnabled ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1.5)
                )
                //                .padding(.bottom)
                .padding(.bottom, UIDevice.current.userInterfaceIdiom == .phone ? 0 : 20)
                
                VStack(alignment: .leading) {
                    HStack{
                        Text ("No Sensitive, Explicit, or Harmful Content")
                            .bold()
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: homeViewModel.iconCreatePostViewWidth1, height: homeViewModel.iconCreatePostViewWidth1)
                            .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                    }
                    
                    Text ("Please refrain from uploading sensitive, explicit, or harmful content, as well as hate speech or harassment.")
                        .opacity(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: proxy.size.width/40)
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: isDarkModeEnabled ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1.5)
                )
                
                Button(action: {
                    Task {
                        _ = try await homeViewModel.createPost(ownerID: "3WBgDcMgEQfodIbaXWTBHvtjYCl2", postCaption: homeViewModel.createNewPostCaption, mediaURL: "", mimeType: "")
                        isNewPost = false
                    }
                    
                    homeViewModel.isPostOnScreen.toggle()
                }) {
                    RoundedRectangle(cornerRadius: proxy.size.width/40)
                        .frame(height: homeViewModel.buttonCreatePostViewHeight)
                        .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                        .overlay(
                            HStack(spacing: 10){
                                
                                Text("Post")
                                    .font(UIDevice.current.userInterfaceIdiom == .phone ? .title3 : .title)
                                    .bold()
                                
                                
                            }
                                .foregroundColor(.white)
                        )
                }
                .padding(.top)
                .padding(.top)
                Spacer()
            }
            .padding(.horizontal)
            .fullScreenCover(isPresented: $homeViewModel.isShowTagListOnIphone) {
                VStack {
                    HStack (alignment: .firstTextBaseline) {
                        Text("Tag a friend")
                            .bold()
                            .font(.title)
                            .padding(.top)
                            .padding(.top)
                        
                        Spacer()
                        
                        Button(action: {
                            homeViewModel.isShowTagListOnIphone = false // Close the sheet
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
                                    gradient: Gradient(colors: isDarkModeEnabled ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ), lineWidth: 1.5)
                                .frame(height: proxy.size.height/15)
                            
                            TextField("", text: $searchText, prompt:  Text("Search a friend...").foregroundColor(isDarkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.5))
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
                                    if !homeViewModel.createNewPostTagList.contains(user) {
                                        homeViewModel.createNewPostTagList.append(user)
                                    }
                                    homeViewModel.isShowTagListOnIphone.toggle()
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
                .foregroundColor(isDarkModeEnabled ? .white : .black)
                .background(!isDarkModeEnabled ? .white : .black)
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled)
            }
            .sheet(isPresented: $homeViewModel.isShowTagListOnIpad) {
                VStack {
                    HStack (alignment: .firstTextBaseline) {
                        Text("Tag a friend")
                            .bold()
                            .font(.title)
                            .padding(.top)
                            .padding(.top)
                        
                        Spacer()
                        
                        Button(action: {
                            homeViewModel.isShowTagListOnIpad = false // Close the sheet
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
                                    gradient: Gradient(colors: isDarkModeEnabled ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ), lineWidth: 1.5)
                                .frame(height: proxy.size.height/15)
                            
                            TextField("", text: $searchText, prompt:  Text("Search a friend...").foregroundColor(isDarkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.5))
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
                                    if !homeViewModel.createNewPostTagList.contains(user) {
                                        homeViewModel.createNewPostTagList.append(user)
                                    }
                                    homeViewModel.isShowTagListOnIpad.toggle()
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
                .foregroundColor(isDarkModeEnabled ? .white : .black)
                .background(!isDarkModeEnabled ? .white : .black)
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled)
            }
            .onAppear {
                homeViewModel.proxySize = proxy.size
            }
            
        }
        
        .foregroundColor(isDarkModeEnabled ? .white : .black)
        .background(!isDarkModeEnabled ? .white : .black)
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(isNewPost: .constant(true), isDarkModeEnabled: .constant(false), proxySize: .constant(CGSize(width: 834.0, height: 0.0)))
    }
}
