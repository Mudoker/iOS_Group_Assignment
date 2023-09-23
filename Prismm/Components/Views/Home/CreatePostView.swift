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
 https://stackoverflow.com/questions/76235908/how-can-i-send-grid-item-to-next-row-if-there-isnt-enough-space-swiftui
 */

import SwiftUI

struct CreatePostView: View {
    // Control state
    @State private var users = ["mudoker7603", "user123", "sampleUser", "testUser", "john_doe", "jane_doe", "user007", "newUser", "oldUser", "demoUser"]
    @Binding var currentUser:User
    @Binding var userSetting:UserSetting
    @ObservedObject var homeVM: HomeViewModel
    @State private var selectedTags: Set<String> = []
    @State var shouldPresentPickerSheet = false
    @State var shouldPresentCamera = false
    @Binding var isNewPost: Bool
    var isDarkModeEnabled: Bool
    @State var isOpenUserListViewOnIphone = false
    @State var isOpenUserListViewOnIpad = false
    @State var isOpenPostTagListViewOnIphone = false
    @State var isOpenPostTagListViewOnIpad = false
    @State var proxySize = CGSize()
    @State var isCreatingPost = false
    
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
                    // Title
                    Text("Create new post")
                        .bold()
                        .font(.title)
                        .padding(.vertical)
                    
                    HStack {
                        // push view
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
                
                // USer infor
                HStack (alignment: .top) {
                    Image("testAvt")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width/7, height: proxy.size.width/7)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(currentUser.username.extractNameFromEmail() ?? currentUser.username)
                            .bold()
                            .font(.title3)
                            .padding(.bottom, 8)
                        
                        // Tag other users
                        Button(action: {
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                isOpenUserListViewOnIpad = true
                            } else {
                                isOpenUserListViewOnIphone = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus.app")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: proxy.size.width/24)
                                    .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                
                                if homeVM.selectedUserTag.isEmpty {
                                    Text("Notify your friend")
                                        .font(.callout)
                                        .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                        .frame(height: proxy.size.height/40)
                                } else {
                                    // Horizontal scroll view
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        ScrollViewReader { scrollProxy in
                                            HStack(spacing: proxy.size.width/30) {
                                                ForEach(homeVM.selectedUserTag, id: \.self) { user in
                                                    HStack {
                                                        Text(user)
                                                            .foregroundColor(.white)
                                                            .font(.callout)
                                                        
                                                        Button(action: {
                                                            // Remove the user from the tagList
                                                            if let index = homeVM.selectedUserTag.firstIndex(of: user) {
                                                                homeVM.selectedUserTag.remove(at: index)
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
                                                .onChange(of: homeVM.selectedUserTag.count) { _ in
                                                    withAnimation {
                                                        // automatically scroll to end
                                                        scrollProxy.scrollTo(homeVM.selectedUserTag.last, anchor: .trailing)
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
                    
                    // Push view
                    Spacer()
                }
                .padding(.top)
                
                // Caption
                ZStack (alignment: .topLeading) {
                    // Background
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
                
                // Post tags
                HStack {
                    Text("Tags")
                        .bold()
                        .font(.title3)
                    
                    // Push view
                    Spacer()
                    
                    // Choose a tag
                    Button(action: {
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            isOpenPostTagListViewOnIpad = true
                        } else {
                            isOpenPostTagListViewOnIphone = true
                        }
                    }) {
                        HStack {
                            // Show tag
                            if homeVM.selectedPostTag.isEmpty {
                                Image(systemName: "tag")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: proxy.size.width/24)
                                    .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                
                                Text("Add a tag")
                                    .font(.callout)
                                    .foregroundColor(!isDarkModeEnabled ? Constants.lightThemeColor : Constants.darkThemeColor)
                                    .frame(height: proxy.size.height/40)
                            } else {
                                // Horizontal scroll view
                                ScrollView(.horizontal, showsIndicators: false) {
                                    ScrollViewReader { scrollProxy in
                                        HStack(spacing: proxy.size.width/30) {
                                            ForEach(homeVM.selectedPostTag, id: \.self) { tag in
                                                HStack {
                                                    Spacer()
                                                    Text(tag)
                                                        .foregroundColor(.white)
                                                        .font(.callout)
                                                    
                                                    Button(action: {
                                                        // Remove the user from the tagList
                                                        if let index = homeVM.selectedPostTag.firstIndex(of: tag) {
                                                            homeVM.selectedPostTag.remove(at: index)
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
                                                .id(tag)
                                            }
                                            .onChange(of: homeVM.selectedPostTag.count) { _ in
                                                withAnimation {
                                                    // automatically scroll to end
                                                    scrollProxy.scrollTo(homeVM.selectedPostTag.last, anchor: .trailing)
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
                    UIImagePickerView(isPresented: $shouldPresentPickerSheet , selectedMedia: $homeVM.newPostSelectedMedia, sourceType: .photoLibrary)
                        .presentationDetents(shouldPresentCamera ? [.large] : [.medium])
                    
                }
                .fullScreenCover(isPresented: $shouldPresentCamera) {
                    UIImagePickerView(isPresented: $shouldPresentCamera , selectedMedia: $homeVM.newPostSelectedMedia, sourceType: .camera)
                        .ignoresSafeArea()
                }
                
                // Post media
                HStack {
                    Text("Post Media")
                        .bold()
                        .font(.title3)
                    
                    // push view
                    Spacer()
                    
                    // Media choosing
                    if homeVM.newPostSelectedMedia != nil {
                        AsyncImage(url: homeVM.newPostSelectedMedia as? URL) { media in
                            media
                                .resizable()
                                .scaledToFit()
                                .frame(height: proxy.size.height/20 )
                            
                        } placeholder: {
                            ProgressView()
                        }
                        
                        
                        Text((homeVM.newPostSelectedMedia?.absoluteString)!)
                            .opacity(0.5)
                        Button {
                            homeVM.newPostSelectedMedia = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                            
                        }
                        .foregroundColor(.gray)
                        
                    } else {
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
                            shouldPresentPickerSheet = false
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
                    UIImagePickerView(isPresented: $shouldPresentPickerSheet , selectedMedia: $homeVM.newPostSelectedMedia, sourceType: .photoLibrary)
                        .presentationDetents(shouldPresentCamera ? [.large] : [.medium])
                    
                }
                .fullScreenCover(isPresented: $shouldPresentCamera) {
                    UIImagePickerView(isPresented: $shouldPresentCamera , selectedMedia: $homeVM.newPostSelectedMedia, sourceType: .camera)
                        .ignoresSafeArea()
                }
                
                // Reminder
                VStack(alignment: .leading) {
                    Text ("No Sensitive, Explicit, or Harmful Content")
                        .bold()
                    
                    Text ("Please refrain from these contents, as well as hate speech or harassment for a safer community.")
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
                
                // Button to create post
                Button(action: {
                    Task {
                        isCreatingPost = true
                        let _ = try await homeVM.createPost()
                        try await homeVM.fetchPosts()
                        isNewPost = false
//                        homeVM.selectedUserTag
                        isCreatingPost = false
                    }
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
            .padding(.horizontal)
            .onAppear {
                //reset selected field when create new post
                proxySize = proxy.size
                homeVM.newPostSelectedMedia = nil
                homeVM.createNewPostCaption = ""
                homeVM.selectedPostTag.removeAll()
                homeVM.selectedUserTag.removeAll()
            }
            .fullScreenCover(isPresented: $isOpenUserListViewOnIphone) {
                UserListView(proxy: $proxySize, searchProfileText: $homeVM.userTagListSearchText, selectedUsers: $homeVM.selectedUserTag, isShowUserTagList: $isOpenUserListViewOnIphone, filteredUsers: filteredUsers, isDarkModeEnabled: isDarkModeEnabled)
            }
            .sheet(isPresented: $isOpenUserListViewOnIpad) {
                UserListView(proxy: $proxySize, searchProfileText: $homeVM.userTagListSearchText, selectedUsers: $homeVM.selectedUserTag, isShowUserTagList: $isOpenUserListViewOnIpad, filteredUsers: filteredUsers, isDarkModeEnabled: isDarkModeEnabled)
            }.fullScreenCover(isPresented: $isOpenPostTagListViewOnIphone) {
                PostTagListView(proxy: $proxySize, searchTagText: $homeVM.userTagListSearchText, selectedTags: $homeVM.selectedPostTag, isShowPostTagList:$isOpenPostTagListViewOnIphone, filteredTags:  filteredTags, isDarkModeEnabled: isDarkModeEnabled)
            }
            .sheet(isPresented: $isOpenPostTagListViewOnIpad) {
                PostTagListView(proxy: $proxySize, searchTagText: $homeVM.userTagListSearchText, selectedTags: $homeVM.selectedPostTag, isShowPostTagList:$isOpenPostTagListViewOnIpad, filteredTags:  filteredTags, isDarkModeEnabled: isDarkModeEnabled)
            }
        }
        .foregroundColor(isDarkModeEnabled ? .white : .black)
        .background(!isDarkModeEnabled ? .white : .black)
    }
}

struct PostTagListView: View {
    // Control state
    @Binding var proxy: CGSize
    @Binding var searchTagText: String
    @Binding var selectedTags: [String]
    @Binding var isShowPostTagList: Bool
    var filteredTags: [String]
    var isDarkModeEnabled: Bool
    
    var body: some View {
        VStack {
            // Title
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading) {
                    Text("Select a tag")
                        .bold()
                        .font(.title)
                        .padding(.top)
                        .padding(.bottom, 2)
                    
                    Text("Choose at most 3 tags")
                        .opacity(0.6)
                        .bold()
                }
                
                Spacer()
                
                Button(action: {
                    isShowPostTagList = false // Close the sheet
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                }
            }
            .padding(.horizontal)
            
            // Search a tag
            TextField("Search Tags", text: $searchTagText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal, .bottom])
            
            // All tags
            ScrollView(showsIndicators: false) {
                FlowLayout {
                    ForEach(filteredTags, id: \.self) { tag in
                        HStack {
                            Button(action: {
                                if !selectedTags.contains(tag){
                                    // Allow at most 3 tags
                                    if selectedTags.count < 3 {
                                        selectedTags.append(tag)
                                    }
                                } else {
                                    // Remove the tag from the tagList
                                    if let index = selectedTags.firstIndex(of: tag) {
                                        selectedTags.remove(at: index)
                                    }
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
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: isDarkModeEnabled ? Constants.buttonGradientColorDark : Constants.buttonGradientColorLight),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
            }
            
            // Push view
            Spacer()
        }
        .foregroundColor(isDarkModeEnabled ? .white : .black)
        .background(isDarkModeEnabled ? Color.black : Color.white)
    }
}

struct UserListView: View {
    // control state
    @Binding var proxy: CGSize
    @Binding var searchProfileText: String
    @Binding var selectedUsers: [String]
    @Binding var isShowUserTagList: Bool
    var filteredUsers: [String]
    var isDarkModeEnabled: Bool
    
    var body: some View {
        VStack {
            // Title
            HStack(alignment: .firstTextBaseline) {
                Text("Tag a friend")
                    .bold()
                    .font(.title)
                    .padding(.top)
                    .padding(.horizontal)
                
                // Push view
                Spacer()
                
                Button(action: {
                    isShowUserTagList = false // Close the sheet
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .padding(.trailing)
                }
            }
            
            // Content
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
                    
                    // Search a firend
                    TextField("", text: $searchProfileText, prompt: Text("Search a friend...").foregroundColor(isDarkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.5))
                        .font(.title3)
                    )
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                }
                .padding([.horizontal, .bottom])
                
                // All users
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

// Screen-width HStack
struct FlowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        
        var currentLineWidth: CGFloat = 0
        var currentLineHeight: CGFloat = 0
        
        for size in sizes {
            if currentLineWidth + size.width > proposal.width ?? 0 {
                totalHeight += currentLineHeight
                currentLineWidth = size.width
                currentLineHeight = size.height
            } else {
                currentLineWidth += size.width
                currentLineHeight = max(currentLineHeight, size.height)
            }
            
            totalWidth = max(totalWidth, currentLineWidth)
        }
        
        totalHeight += currentLineHeight
        
        return .init(width: totalWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var currentLineHeight: CGFloat = 0
        
        for index in subviews.indices {
            if currentX + sizes[index].width > (proposal.width ?? 0) {
                currentY += currentLineHeight
                currentLineHeight = 0
                currentX = bounds.minX
            }
            
            subviews[index].place(
                at: .init(
                    x: currentX + sizes[index].width / 2,
                    y: currentY + sizes[index].height / 2
                ),
                anchor: .center,
                proposal: ProposedViewSize(sizes[index])
            )
            
            currentLineHeight = max(currentLineHeight, sizes[index].height)
            currentX += sizes[index].width
        }
    }
}

//struct CreatePostView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatePostView(isNewPost: .constant(true), isDarkModeEnabled: .constant(false), homeVM: HomeViewModel())
//    }
//}
