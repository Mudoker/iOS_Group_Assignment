//
//  DiscoverView.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 24/09/2023.
//



import Foundation
import SwiftUI
import Firebase

import AVKit
import Kingfisher

struct DiscoverView: View {
    @StateObject var discoverVm  = DiscoverViewModel()
    
    @State var currentUser = User(id: "default", account: "default@gmail.com")
    @State var userSetting = UserSetting(id: "default", darkModeEnabled: false, language: "en", faceIdEnabled: true, pushNotificationsEnabled: true, messageNotificationsEnabled: false)
    @State var selectedPost = Post(id: "", ownerID: "", creationDate: Timestamp(), isAllowComment: true)
    @ObservedObject var notiVM: NotificationViewModel
    
    //    @State var randomPost : [Post] = []
    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var authVM :AuthenticationViewModel
    @ObservedObject var settingVM:SettingViewModel
    
    @Namespace private var animation
    
    var filteredTags: [String] {
        if homeVM.postTagListSearchText.isEmpty {
            return Constants.availableTags
        } else {
            return Constants.availableTags.filter { $0.localizedCaseInsensitiveContains(homeVM.postTagListSearchText) }
        }
    }
    
    var body: some View {
        GeometryReader { reader in
            VStack{
                VStack(alignment: .leading){
                    Text("\(discoverVm.birthMonth?.option == "Posts" ? "What do people think?" : (discoverVm.birthMonth?.option == "People" ? "People around you" : "Let's explore"))")
                        .padding(.leading,20)
                        .font(.title)
                        .fontWeight(.semibold)
                    ScrollViewReader{ proxy in
                        ScrollView(.vertical,showsIndicators: false){
                            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                                HStack{
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)
                                        TextField("Search message", text: $discoverVm.searchTerm)
                                            .foregroundColor(.black)
                                            .autocorrectionDisabled(true)
                                            .autocapitalization(.none)
                                        
                                        
                                        Button(action: {
                                            
                                            withAnimation(.spring()) {
                                                print(discoverVm.searchTerm)
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                        
                                    }
                                    .frame(width: reader.size.width - 85, height: 25)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .opacity(discoverVm.searchState ? 1 : 0)
                                    VStack{
                                        Button{
                                            discoverVm.isOpenFilterOnIphone = true
                                        } label: {
                                            Image(systemName: "line.3.horizontal.decrease.circle")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .popover(isPresented : $discoverVm.isOpenFilterOnIphone, attachmentAnchor: .point(.center), arrowEdge: .leading){
                                            filterView(birthMonth: $discoverVm.birthMonth, isFilter: $discoverVm.isOpenFilterOnIphone, homeVM: homeVM, isOpenFilterOnIphone: $discoverVm.isOpenFilterOnIphone)
                                        }
                                    }
                                    .frame(height: 25)
                                }
                                if (discoverVm.birthMonth?.option == "Posts") {
                                    ScrollView(.horizontal){
                                        LazyHStack{
                                            ForEach(filteredTags, id: \.self){ tag in
                                                Text(tag)
                                                    .fontWeight(discoverVm.activeTab == tag ? .semibold : .regular)
                                                    .background(alignment: .bottom, content: {
                                                        if discoverVm.activeTab == tag{
                                                            Capsule()
                                                                .fill(.black)
                                                                .frame(height: 5)
                                                                .padding(.horizontal,-5)
                                                                .offset(y:10)
                                                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                                        }
                                                    })
                                                    .padding(.trailing,10)
                                                    .contentShape(Rectangle())
                                                //                                                .background(.red)
                                                    .onTapGesture {
                                                        withAnimation(.easeOut(duration: 0.3)){
                                                            discoverVm.activeTab = tag
                                                        }
                                                    }
                                            }
                                        }
                                        Divider()
                                    }
                                    .padding(.leading,20)
                                }
                                
                                if (discoverVm.birthMonth?.option == "Posts") {
                                    ForEach(discoverVm.postList.filter { post in
                                        (post.tag.contains(discoverVm.activeTab) && discoverVm.searchTerm.isEmpty
                                         || discoverVm.activeTab == "All" && discoverVm.searchTerm.isEmpty
                                         || (post.unwrappedOwner!.username.localizedCaseInsensitiveContains(discoverVm.searchTerm) && (post.tag.contains(discoverVm.activeTab) || discoverVm.activeTab == "All"))
                                         || (post.caption!.localizedCaseInsensitiveContains(discoverVm.searchTerm) && (post.tag.contains(discoverVm.activeTab) || discoverVm.activeTab == "All")))
                                    },id: \.id) { post in
                                        //                                    Text(post.caption!)
                                        //                                    Text(searchTerm)
                                        PostView(post: post, currentUser: $currentUser, userSetting: $userSetting, homeViewModel: homeVM, notiVM: notiVM, selectedPost: $selectedPost, isAllowComment: $discoverVm.isSelectedPostAllowComment)
                                            .padding(.bottom, 50)
                                    }
                                }
                                else if (discoverVm.birthMonth?.option == "People") {
                                    ForEach(discoverVm.allUser.filter{ user in
                                        (user.username.localizedCaseInsensitiveContains(discoverVm.searchTerm) || discoverVm.searchTerm.isEmpty)
                                    }, id: \.id){ user in
                                        HStack{
                                            //  User information
                                            Image("testAvt")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: UIScreen.main.bounds.width/(UIDevice.current.userInterfaceIdiom == .phone ? 6 : 10))
                                                .clipShape(Circle())
                                            
                                            VStack(alignment: .leading){
                                                Text(user.username)
                                                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 24))
                                                    .fontWeight(.medium)
                                                
                                                Text(user.bio ?? "")
                                                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 16 : 20))
                                                    .opacity(0.4)
                                            }
                                            .foregroundColor(.black)
                                            Spacer()
                                            
                                        }
                                        .padding(10)
                                        .padding(.horizontal,10)
                                        .frame(minWidth: 0,maxWidth: .infinity)
                                    }
                                }
                                else if (discoverVm.birthMonth?.option == "For you"){
                                    if (discoverVm.searchTerm.isEmpty){
                                        HStack{
                                            Text("Posts")
                                                .font(.title)
                                                .fontWeight(.bold)
                                            Spacer()
                                            Text("see all")
                                                .foregroundColor(.blue)
                                                .onTapGesture{
                                                    withAnimation(.easeInOut(duration: 0.3)){
                                                        discoverVm.birthMonth?.option = "Posts"
                                                    }
                                                }
                                        }
                                        .padding(.horizontal,15)
                                        ForEach(discoverVm.defaultPost) { post in
                                            PostView(post: post, currentUser: $currentUser, userSetting: $userSetting, homeViewModel: homeVM, notiVM: notiVM, selectedPost: $selectedPost, isAllowComment: $discoverVm.isSelectedPostAllowComment)
                                        }
                                        
                                        HStack{
                                            Text("People")
                                                .font(.title)
                                                .fontWeight(.bold)
                                            Spacer()
                                            Text("see all")
                                                .foregroundColor(.blue)
                                                .onTapGesture{
                                                    withAnimation(.easeInOut(duration: 0.3)){
                                                        discoverVm.birthMonth?.option = "People"
                                                    }
                                                }
                                        }
                                        .padding(.horizontal,15)
                                        ScrollView(.horizontal){
                                            LazyHStack{
                                                ForEach(discoverVm.defaultPeople) { person in
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .frame(width: 260, height: 300)
                                                        .foregroundColor(Color(.gray).opacity(0.2))
                                                        .overlay{
                                                            VStack{
                                                                //  User information
                                                                Image("testAvt")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: UIScreen.main.bounds.width/(UIDevice.current.userInterfaceIdiom == .phone ? 2 : 10))
                                                                    .clipShape(Circle())
                                                                
                                                                VStack(alignment: .leading){
                                                                    Text(person.username)
                                                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 24))
                                                                        .fontWeight(.medium)
                                                                    
                                                                    Text(person.bio ?? "")
                                                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 16 : 20))
                                                                        .opacity(0.4)
                                                                }
                                                                .frame(width: 140)
                                                                .foregroundColor(.black)
                                                                Spacer()
                                                                
                                                            }
                                                            .padding(10)
                                                            .padding(.horizontal,10)
                                                            .frame(minWidth: 0,maxWidth: .infinity)
                                                        }
                                                }
                                            }
                                        }
                                        .padding(.horizontal,15)
                                    }
                                    else{
//                                        zip(discoverVm.allUser, discoverVm.$postList).forEach{ user, post in
//                                            
//                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear{
                    Task{
                        currentUser = try await APIService.fetchCurrentUserData() ?? User(id: "default", account: "default@gmail.com")
                        userSetting = try await APIService.fetchCurrentSettingData() ?? UserSetting(id: "default", darkModeEnabled: false, language: "en", faceIdEnabled: false, pushNotificationsEnabled: false, messageNotificationsEnabled: false)
                        notiVM.fetchNotifcationRealTime(userId: currentUser.id)
                        
                        try await discoverVm.fetchAllPosts()
                        try await discoverVm.fetchAllUser()
                        if (!discoverVm.postList.isEmpty){
                            discoverVm.getDefaultPostList()
                        }
                        
                        if (!discoverVm.allUser.isEmpty){
                            discoverVm.getDefaultPeopleList()
                        }
                        
                        //                     randomPost = getRandomPosts()
                        
                        //                    print(randomPost)
                    }
                }
                .refreshable {
                    discoverVm.getRandomPosts()
                    discoverVm.getRandomPeople()
                }
            }
        }
        
    }
    
}


struct filterView : View{
    @Binding var birthMonth: DropdownMenuOption?
    @Binding var isFilter : Bool
    @ObservedObject var homeVM: HomeViewModel
    @Binding var isOpenFilterOnIphone : Bool
    var body: some View{
        VStack{
            VStack{
                Button{
                    isOpenFilterOnIphone = false
                } label: {
                    Image(systemName: "x.circle")
                }
            }
            DropdownMenu(
                selectedOption: self.$birthMonth,
                placeholder: "Select your birth month",
                options: DropdownMenuOption.testAllMonths
            )
        }
        .frame(width: 200, height: 200)
        .presentationCompactAdaptation(.popover)
    }
}

//struct DiscoverView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscoverView(notiVM: <#T##NotificationViewModel#>, homeVM: <#T##HomeViewModel#>, authVM: <#T##AuthenticationViewModel#>, settingVM: <#T##SettingViewModel#>)
//    }
//}

