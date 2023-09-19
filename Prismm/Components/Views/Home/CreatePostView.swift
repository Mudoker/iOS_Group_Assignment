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
    
    @State var shouldPresentPickerSheet = false
    @State var shouldPresentCamera = false
    @State var selected = false

    
    @Binding var isNewPost: Bool
    @Binding var isDarkModeEnabled: Bool
    
    @ObservedObject var homeVM = HomeViewModel()
    
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
                                homeVM.isShowTagListOnIpad.toggle()
                            } else {
                                homeVM.isShowTagListOnIphone.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus.app")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: proxy.size.width/24)
                                    .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                
                                if homeVM.createNewPostTagList.isEmpty {
                                    Text("Notify your friend")
                                        .font(.callout)
                                        .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                        .frame(height: proxy.size.height/40)
                                } else {
                                    // Horizontal scroll view
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        ScrollViewReader { scrollProxy in
                                            HStack(spacing: proxy.size.width/30) {
                                                ForEach(homeVM.createNewPostTagList, id: \.self) { user in
                                                    HStack {
                                                        Text(user)
                                                            .foregroundColor(.white)
                                                            .font(.callout)
                                                        
                                                        Button(action: {
                                                            // Remove the user from the tagList
                                                            if let index = homeVM.createNewPostTagList.firstIndex(of: user) {
                                                                homeVM.createNewPostTagList.remove(at: index)
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
                                                .onChange(of: homeVM.createNewPostTagList.count) { _ in
                                                    withAnimation {
                                                        // automatically scroll to end
                                                        scrollProxy.scrollTo(homeVM.createNewPostTagList.last, anchor: .trailing)
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
                    
                    TextField("", text: $homeVM.createNewPostCaption, prompt:  Text("Share your updates...").foregroundColor(isDarkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.5))
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
                        
                        if selected {
                            AsyncImage(url: homeVM.newPostSelectedMedia as? URL) { media in
                                media
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: proxy.size.height/20 ) // Set the desired width and height for your circular image
                                    
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text((homeVM.newPostSelectedMedia?.absoluteString)!)
                                .opacity(0.8)
                        }else{
                            Button(action: {
                                shouldPresentCamera = false
                                shouldPresentPickerSheet = true
                            }) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: proxy.size.width/12)
                                    .foregroundColor(.green)
                            }
                            .padding(.trailing, 8)
                            
                            
                            Button(action: {
                                shouldPresentCamera = true
                                shouldPresentPickerSheet = true
                            }) {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: proxy.size.width/12)
                                    .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                            }
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
                    .padding(.bottom)
                    .sheet(isPresented: $shouldPresentPickerSheet) {
                        UIImagePickerView(sourceType: shouldPresentCamera ? .camera : .photoLibrary , isPresented: $shouldPresentPickerSheet, selectedMedia: $homeVM.newPostSelectedMedia)
                            .onDisappear {
                                selected = true
                            }
                    }
                
                
                
                
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
                            gradient: Gradient(colors: isDarkModeEnabled ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1.5)
                )
                
                Button(action: {
                    Task {
                        let _ = try await homeVM.createPost()
                       
                        isNewPost = false
                    }
                    
                    homeVM.isPostOnScreen.toggle()
                }) {
                    RoundedRectangle(cornerRadius: proxy.size.width/40)
                        .frame(height: proxy.size.width/7)
                        .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
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
            .fullScreenCover(isPresented: $homeVM.isShowTagListOnIphone) {
                VStack {
                    HStack (alignment: .firstTextBaseline) {
                        Text("Tag a friend")
                            .bold()
                            .font(.title)
                            .padding(.top)
                            .padding(.top)

                        Spacer()
                        
                        Button(action: {
                            homeVM.isShowTagListOnIphone = false // Close the sheet
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
                                    if !homeVM.createNewPostTagList.contains(user) {
                                        homeVM.createNewPostTagList.append(user)
                                    }
                                    homeVM.isShowTagListOnIphone.toggle()
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
            .sheet(isPresented: $homeVM.isShowTagListOnIpad) {
                VStack {
                    HStack (alignment: .firstTextBaseline) {
                        Text("Tag a friend")
                            .bold()
                            .font(.title)
                            .padding(.top)
                            .padding(.top)

                        Spacer()
                        
                        Button(action: {
                            homeVM.isShowTagListOnIpad = false // Close the sheet
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
                                    if !homeVM.createNewPostTagList.contains(user) {
                                        homeVM.createNewPostTagList.append(user)
                                    }
                                    homeVM.isShowTagListOnIpad.toggle()
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
        }
        .foregroundColor(isDarkModeEnabled ? .white : .black)
        .background(!isDarkModeEnabled ? .white : .black)
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(isNewPost: .constant(true), isDarkModeEnabled: .constant(false))
    }
}
