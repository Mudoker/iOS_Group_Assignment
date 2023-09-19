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
    @State private var users = ["mudoker7603", "user123", "sampleUser", "testUser", "john_doe", "jane_doe", "user007", "newUser", "oldUser", "demoUser"]
    @State private var selectedTags: Set<String> = []
    
    @State var shouldPresentPickerSheet = false
    @State var shouldPresentCamera = false
    @State var selected = false
    
    
    @Binding var isNewPost: Bool
    @Binding var isDarkModeEnabled: Bool
    @ObservedObject var homeVM: HomeViewModel
    @State var isOpenUserListViewOnIphone = false
    @State var isOpenUserListViewOnIpad = false
    @State var isOpenPostTagListViewOnIphone = false
    @State var isOpenPostTagListViewOnIpad = false
    
    @State var proxySize = CGSize()
    var filteredUsers: [String] {
        if homeVM.userTagListSearchText.isEmpty {
            return users
        } else {
            return users.filter { $0.localizedCaseInsensitiveContains(homeVM.userTagListSearchText) }
        }
    }
    
    var filteredTags: [String] {
        if homeVM.postTagListSearchText.isEmpty {
            return Constants.availableTags
        } else {
            return Constants.availableTags.filter { $0.localizedCaseInsensitiveContains(homeVM.postTagListSearchText) }
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
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("mudoker_7603")
                                .bold()
                                .font(.title3)
                                .padding(.bottom, 8)
                            
                            Button(action: {
                                if UIDevice.current.userInterfaceIdiom == .pad {
                                    isOpenUserListViewOnIpad = true
                                } else {
                                    isOpenUserListViewOnIphone = true
                                }
                                print("ok")
                            }) {
                                HStack {
                                    Image(systemName: "plus.app")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: proxy.size.width/24)
                                        .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                    
                                    if homeVM.selectedPostTagList.isEmpty {
                                        Text("Notify your friend")
                                            .font(.callout)
                                            .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                            .frame(height: proxy.size.height/40)
                                    } else {
                                        // Horizontal scroll view
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            ScrollViewReader { scrollProxy in
                                                HStack(spacing: proxy.size.width/30) {
                                                    ForEach(homeVM.selectedPostTagList, id: \.self) { user in
                                                        HStack {
                                                            Text(user)
                                                                .foregroundColor(.white)
                                                                .font(.callout)
                                                            
                                                            Button(action: {
                                                                // Remove the user from the tagList
                                                                if let index = homeVM.selectedPostTagList.firstIndex(of: user) {
                                                                    homeVM.selectedPostTagList.remove(at: index)
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
                                                    .onChange(of: homeVM.selectedPostTagList.count) { _ in
                                                        withAnimation {
                                                            // automatically scroll to end
                                                            scrollProxy.scrollTo(homeVM.selectedPostTagList.last, anchor: .trailing)
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
                            .frame(height: proxy.size.height/4)
                        
                        TextField("", text: $homeVM.createNewPostCaption, prompt:  Text("Share your updates...").foregroundColor(isDarkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.5))
                            .font(.title3)
                        )
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .padding()
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Text("Tags")
                            .bold()
                            .font(.title3)
                        Spacer()
                        
                        Button(action: {
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                homeVM.isShowUserTagListOnIpad.toggle()
                                isOpenPostTagListViewOnIpad = homeVM.isShowUserTagListOnIpad
                            } else {
                                homeVM.isShowUserTagListOnIphone.toggle()
                                isOpenPostTagListViewOnIphone = homeVM.isShowUserTagListOnIphone
                            }
                        }) {
                            HStack {
                                Image(systemName: "tag")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: proxy.size.width/24)
                                    .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                
                                if homeVM.selectedPostTagList.isEmpty {
                                    Text("Add a tag")
                                        .font(.callout)
                                        .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                        .frame(height: proxy.size.height/40)
                                } else {
                                    // Horizontal scroll view
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        ScrollViewReader { scrollProxy in
                                            HStack(spacing: proxy.size.width/30) {
                                                ForEach(homeVM.selectedPostTagList, id: \.self) { user in
                                                    HStack {
                                                        Text(user)
                                                            .foregroundColor(.white)
                                                            .font(.callout)
                                                        
                                                        Button(action: {
                                                            // Remove the user from the tagList
                                                            if let index = homeVM.selectedPostTagList.firstIndex(of: user) {
                                                                homeVM.selectedPostTagList.remove(at: index)
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
                                                .onChange(of: homeVM.selectedPostTagList.count) { _ in
                                                    withAnimation {
                                                        // automatically scroll to end
                                                        scrollProxy.scrollTo(homeVM.selectedPostTagList.last, anchor: .trailing)
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
                        UIImagePickerView(sourceType: shouldPresentCamera ? .camera : .photoLibrary , isPresented: $shouldPresentPickerSheet, selectedMedia: $homeVM.selectedMedia)
                            .onDisappear {
                                selected = true
                            }
                    }
                    
                    if selected {
                        AsyncImage(url: homeVM.selectedMedia as? URL) { media in
                            media
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 200, height: 200 ) // Set the desired width and height for your circular image
                        
                    } else {
                        HStack {
                            Text("Post Media")
                                .bold()
                                .font(.title3)
                            Spacer()
                            
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
                            UIImagePickerView(sourceType: shouldPresentCamera ? .camera : .photoLibrary , isPresented: $shouldPresentPickerSheet, selectedMedia: $homeVM.selectedMedia)
                                .onDisappear {
                                    selected = true
                                }
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
                            let _ = try await homeVM.createPost(ownerID: Constants.currentUserID, postCaption: homeVM.createNewPostCaption, mediaURL: homeVM.uploadMediaToFirebase(), mimeType: homeVM.mimeType(for: try Data(contentsOf: homeVM.selectedMedia as? URL ?? URL(fileURLWithPath: ""))))
                            let  _ = try await homeVM.createPost(ownerID: "3WBgDcMgEQfodIbaXWTBHvtjYCl2", postCaption: homeVM.createNewPostCaption, mediaURL: "", mimeType: "")
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
                    
                    Spacer()
                }
                .onAppear {
                    proxySize = proxy.size
                }
                .padding(.horizontal)
                .fullScreenCover(isPresented: $isOpenUserListViewOnIphone) {
                    UserListView(proxy: $proxySize, isDarkModeEnabled: $isDarkModeEnabled, searchProfileText: $homeVM.userTagListSearchText, selectedUsers: $homeVM.selectedUserTagList, isShowUserTagList: $isOpenUserListViewOnIphone, filteredUsers: filteredUsers)
                }
                .sheet(isPresented: $isOpenUserListViewOnIpad) {
                    UserListView(proxy: $proxySize, isDarkModeEnabled: $isDarkModeEnabled, searchProfileText: $homeVM.userTagListSearchText, selectedUsers: $homeVM.selectedUserTagList, isShowUserTagList: $isOpenUserListViewOnIpad, filteredUsers: filteredUsers)
                }
        }
        .foregroundColor(isDarkModeEnabled ? .white : .black)
        .background(!isDarkModeEnabled ? .white : .black)
    }
}

struct tagPostListView: View {
    @Binding var searchTagText: String
    var filteredTags: [String]
    @Binding var proxy: CGSize
    @Binding var isDarkModeEnabled: Bool
    @Binding var selectedTags: Set<String>
    
    var body: some View {
        VStack {
            Text("Select Tags")
                .font(.title)
                .bold()
                .padding()
            
            TextField("Search Tags", text: $searchTagText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal, .bottom])
            
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 100))],
                spacing: 8
            ) {
                ForEach(filteredTags, id: \.self) { tag in
                    Button(action: {
                        if selectedTags.contains(tag) {
                            selectedTags.remove(tag)
                        } else {
                            selectedTags.insert(tag)
                        }
                    }) {
                        HStack {
                            Text(tag)
                                .font(.callout)
                            
                            if selectedTags.contains(tag) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: proxy.width / 40)
                                .stroke(LinearGradient(
                                    gradient: Gradient(colors: isDarkModeEnabled ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ), lineWidth: 1.5)
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                }
            }
        }
        .foregroundColor(isDarkModeEnabled ? .white : .black)
        .background(!isDarkModeEnabled ? .white : .black)
    }
}

struct UserListView: View {
    @Binding var proxy: CGSize
    @Binding var isDarkModeEnabled: Bool
    @Binding var searchProfileText: String
    @Binding var selectedUsers: [String]
    @Binding var isShowUserTagList: Bool
    var filteredUsers: [String]

    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text("Tag a friend")
                    .bold()
                    .font(.title)
                    .padding(.top)
                    .padding(.horizontal)

                Spacer()

                Button(action: {
                    isShowUserTagList = false // Close the sheet
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .padding(.trailing)
                }
            }

            VStack {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: proxy.width / 40)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: isDarkModeEnabled ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                        .frame(height: proxy.height / 15)

                    TextField("", text: $searchProfileText, prompt: Text("Search a friend...").foregroundColor(isDarkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.5))
                            .font(.title3)
                    )
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                }
                .padding([.horizontal, .bottom])

                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredUsers, id: \.self) { user in
                            Button(action: {
                                if !selectedUsers.contains(user) {
                                    selectedUsers.append(user)
                                }
                                isShowUserTagList.toggle()
                            }) {
                                HStack {
                                    Image("testAvt")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: proxy.width / 7, height: proxy.width / 7)
                                        .clipShape(Circle())

                                    Text(user)
                                    Spacer()
                                }
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: proxy.width / 40)
                                        .fill(
                                            isDarkModeEnabled ? Constants.darkThemeColor : Constants.lightThemeColor.opacity(0.4)
                                        )
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }
        .foregroundColor(isDarkModeEnabled ? .white : .black)
        .background(isDarkModeEnabled ? Color.black : Color.white)
        .presentationDetents([.medium, .large])
        .presentationBackgroundInteraction(.enabled)
    }
}



struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(isNewPost: .constant(true), isDarkModeEnabled: .constant(false), homeVM: HomeViewModel())
    }
}
