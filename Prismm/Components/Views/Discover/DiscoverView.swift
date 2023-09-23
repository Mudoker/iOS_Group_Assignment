//
//  DiscoverView.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 23/09/2023.
//

import Foundation
import SwiftUI
import Firebase
struct DiscoverView: View {
    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var authVM :AuthenticationViewModel
    @ObservedObject var settingVM:SettingViewModel
    @State var selectedPost = Post(id: "", ownerID: "", creationDate: Timestamp(), isAllowComment: true)
    
    @State var activeTab : String = "All"
    @Namespace private var animation
    
    
    @State var searchTerm : String = ""
    @State var searchState : Bool = true
    
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
                    Text("Explore")
                        .padding(.leading,20)
                        .font(.title)
                        .fontWeight(.semibold)
                    ScrollViewReader{ proxy in
                        ScrollView(.vertical,showsIndicators: false){
                            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    TextField("Search message", text: $searchTerm)
                                        .foregroundColor(.black)
                                        .autocorrectionDisabled(true)
                                        .autocapitalization(.none)
                                    
                                    Button(action: {
                                        
                                        withAnimation(.spring()) {
                                            print(searchTerm)
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    
                                }
                                .frame(width: reader.size.width - 50, height: 25)
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .opacity(searchState ? 1 : 0)
                                
                                ScrollView(.horizontal,showsIndicators: false){
                                    LazyHStack{
                                        ForEach(filteredTags, id: \.self){ tag in
                                            Text(tag)
                                                .fontWeight(activeTab == tag ? .semibold : .regular)
                                                .background(alignment: .bottom, content: {
                                                    if activeTab == tag{
                                                        Capsule()
                                                            .fill(.black)
                                                            .frame(height: 5)
                                                            .padding(.horizontal,-5)
                                                            .offset(y:10)
                                                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                                    }
                                                })
                                                .padding(.horizontal,10)
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    withAnimation(.easeOut(duration: 0.3)){
                                                        activeTab = tag
                                                    }
                                                }
                                        }
                                    }
                                    
                                    Divider()
                                }
                                .padding(.leading,20)
//                                .background(.red)
                                
                                ForEach(homeVM.fetchedAllPosts.filter { post in
                                    (post.tag.contains(activeTab) && searchTerm.isEmpty
                                     || activeTab == "All" && searchTerm.isEmpty
                                     || (post.user!.username.localizedCaseInsensitiveContains(searchTerm) && (post.tag.contains(activeTab) || activeTab == "All"))
                                     || (post.caption!.localizedCaseInsensitiveContains(searchTerm) && (post.tag.contains(activeTab) || activeTab == "All")))
                                },id: \.id) { post in
//                                    Text(post.caption!)
//                                    Text(searchTerm)
                                    PostView(post: post, homeViewModel: homeVM, settingVM: settingVM, select: $selectedPost)
                                        .padding(.bottom, 50)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(homeVM:  HomeViewModel(), authVM: AuthenticationViewModel(), settingVM: SettingViewModel())
    }
}



