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
 
 Created  date: 11/09/2023
 Last modified: 18/09/2023
 Acknowledgement: None
 */

import SwiftUI

struct TabBar: View {
    // Control state
    @State private var tabSelection = 0
    @StateObject var notiVM = NotificationViewModel()
    @StateObject var homeVM = HomeViewModel()
    
    
//    @State var currentUser = User(id: "default", account: "default@gmail.com")
//    @State var userSetting = UserSetting(id: "default", darkModeEnabled: false, language: "en", faceIdEnabled: true, pushNotificationsEnabled: true, messageNotificationsEnabled: false)
    
    @EnvironmentObject var manager: AppManager
    @EnvironmentObject var tabVM: TabBarViewModel
    
    // Localization
    @AppStorage("selectedLanguage") var selectedLanguage = "vi"
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            TabView(selection: $tabSelection) {
                NavigationView {
                    HomeView(homeViewModel: homeVM, notiVM: notiVM)
                }
                .tag(0)
                
                NavigationView {
                    AllChat()
                }
                .tag(1)
                
                NavigationView {
                    DiscoverView(notiVM: notiVM, homeVM: homeVM)
                }
                .tag(2)
                
                NavigationView {
                    NotificationView(notiVM: notiVM)
                }
                .tag(3)
                
                NavigationView {
                    ProfileView()
                }
                .tag(4)
            }
            .onAppear {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                Task {
                    print("OK")
                        tabVM.currentUser = try await APIService.fetchCurrentUserData() ?? User(id: "default", account: "default@gmail.com")
                    tabVM.userSetting = try await APIService.fetchCurrentSettingData() ?? UserSetting(id: "default", darkModeEnabled: false, language: "en", faceIdEnabled: false, pushNotificationsEnabled: false, messageNotificationsEnabled: false)
                    
                    homeVM.isFetchingPost = true
                    homeVM.fetchUserFavouritePost(forUserId: tabVM.currentUser.id)
                    try await homeVM.fetchPosts()
                    homeVM.isFetchingPost = false
                }
            }
            .environment(\.locale, Locale(identifier: selectedLanguage)) // Localization
            .overlay(alignment: .bottom) {
                CustomTabbar(tabSelection: $tabSelection)
            }
            .onChange(of: manager.isSignIn, perform: { newValue in
                print("reload")
                tabSelection = 0
            })
            
        } else {
            NavigationStack {
                TabView(selection: $tabSelection) {
                    NavigationView {
                        HomeView(homeViewModel: homeVM, notiVM: notiVM)
                            .onAppear {
                                Task {
                                    homeVM.isFetchingPost = true
                                    homeVM.fetchUserFavouritePost(forUserId: tabVM.currentUser.id)
                                    try await homeVM.fetchPosts()
                                    homeVM.isFetchingPost = false
                                    
                                }
                            }
                    }
                    .tag(0)
                    
                    NavigationView {
                        AllChat()
                    }
                    .tag(1)
                    
                    NavigationView {
                        DiscoverView(notiVM: notiVM, homeVM: homeVM)
                    }
                    .tag(2)
                    
                    NavigationView {
                        NotificationView(notiVM: notiVM)
                    }
                    .tag(3)
                    
                    NavigationView {
                        ProfileView()
                    }
                    .tag(4)
                }
                .onAppear {
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.configureWithDefaultBackground()
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                    Task {
                        print("OK")
                        tabVM.currentUser = try await APIService.fetchCurrentUserData() ?? User(id: "default", account: "default@gmail.com")
                        tabVM.userSetting = try await APIService.fetchCurrentSettingData() ?? UserSetting(id: "default", darkModeEnabled: false, language: "en", faceIdEnabled: false, pushNotificationsEnabled: false, messageNotificationsEnabled: false)
                        
                        homeVM.isFetchingPost = true
                        homeVM.fetchUserFavouritePost(forUserId: tabVM.currentUser.id)
                        try await homeVM.fetchPosts()
                        homeVM.isFetchingPost = false
                    }
                }
                .environment(\.locale, Locale(identifier: selectedLanguage)) // Localization
                .overlay(alignment: .bottom) {
                    CustomTabbar(tabSelection: $tabSelection)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onChange(of: manager.isSignIn, perform: { newValue in
                print("reload")
                tabSelection = 0
            })
            
        }
    }
}


struct CustomTabbar: View {
    // Control state
    @Binding var tabSelection: Int
    @Namespace var namespace
    
    // Localization
    @AppStorage("selectedLanguage") var selectedLanguage = "vi"
    
    // List of views
    let tabItems: [(image: String, page: String)] = [
        ("house", "Dashboard"),
        ("bubble.middle.bottom", "Message"),
        ("magnifyingglass", "Explore"),
        ("bell", "Notification"),
        ("person", "Profile"),
    ]
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                // Push view
                Spacer()
                
                // content
                HStack {
                    // Push view
                    Spacer()
                    
                    HStack(spacing: (proxy.size.width / 2.5) / CGFloat(tabItems.count + 1)) {
                        ForEach(0..<5) { index in // Use tabItems.count here
                            Button {
                                tabSelection = index // Update the binding
                                
                            } label: {
                                VStack {
                                    Image(systemName: tabItems[index].image)
                                        .font(.title3)
                                        .foregroundColor(tabSelection == index ? .blue : .gray)
                                        .frame(width: 24, height: 24)
                                        .cornerRadius(10)
                                        .matchedGeometryEffect(id: tabItems[index].page, in: namespace)
                                    
                                    Text(LocalizedStringKey(tabItems[index].page))
                                        .font(.caption)
                                        .foregroundColor(tabSelection == index ? .blue : .gray)
                                }
                            }
                        }
                    }
                    
                    // Push view
                    Spacer()
                }
                .padding(.vertical)
            }
            .edgesIgnoringSafeArea(.all)
        }
        
        .environment(\.locale, Locale(identifier: selectedLanguage)) // Localization
    }
}

//struct TabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar(homeVM: HomeViewModel(), profileVM: ProfileViewModel())
//    }
//}
