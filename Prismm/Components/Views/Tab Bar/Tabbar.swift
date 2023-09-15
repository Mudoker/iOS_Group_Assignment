/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Doan Huu Quoc
 ID: 3927776
 Created  date: 18/08/2023
 Last modified: 20/08/2023
 Acknowledgement:
 */

import SwiftUI

struct TabBar: View {
    // Control state
    @State private var tabSelection = 0
    @ObservedObject var uploadVM = UploadPostViewModel()

    // Localization
    @AppStorage("selectedLanguage") var selectedLanguage = "en"
//    init(uploadVM: UploadPostViewModel) {
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(red: 0.85, green: 0.95, blue: 1.0, alpha: 1.0)
//        UITabBar.appearance().standardAppearance = appearance
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone{
            TabView(selection: $tabSelection) {
                NavigationView {
                    HomeView()
                }
                .tag(0)
                
                NavigationView {
                    AllChat()
                }
                .tag(1)
                
                NavigationView {
                    AllChat()
                }
                .tag(2)
                
                NavigationView {
                    NotificationView()
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
            }
            .environment(\.locale, Locale(identifier: selectedLanguage)) // Localization
            .overlay(alignment: .bottom) {
                CustomTabbar(tabSelection: $tabSelection)
            }
        } else {
            NavigationStack {
                TabView(selection: $tabSelection) {
                    NavigationView {
                        HomeView()
                    }
                    .tag(0)
                    
                    NavigationView {
                        AllChat()
                    }
                    .tag(1)
                    
                    NavigationView {
                        AllChat()
                    }
                    .tag(2)
                    
                    NavigationView {
                        NotificationView()
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
                }
                .environment(\.locale, Locale(identifier: selectedLanguage)) // Localization
                .overlay(alignment: .bottom) {
                    CustomTabbar(tabSelection: $tabSelection)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}


struct CustomTabbar: View {
    // Control state
    @Binding var tabSelection: Int
    @Namespace var namespace
    
    // Localization
    @AppStorage("selectedLanguage") var selectedLanguage = "en"
    
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
                                print(tabSelection)
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

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(uploadVM: UploadPostViewModel())
    }
}
