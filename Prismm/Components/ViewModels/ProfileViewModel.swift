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
  Last modified: 14/09/2023
  Acknowledgement: None
*/

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import FirebaseStorage
import MobileCoreServices
import AVFoundation
import FirebaseFirestoreSwift

class ProfileViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var hasStoryHightlight = false
    @Published var isSetting = false
    @Published var isShowAllUserPost = 1
    {
        didSet{
            switch isShowAllUserPost{
            case 1:
                withAnimation {
                    indicatorOffset = -(UIScreen.main.bounds.width/4)
                }
                
            case 0:
                withAnimation {
                    indicatorOffset = (UIScreen.main.bounds.width/4)
                }
            default:
                withAnimation {
                    indicatorOffset = -(UIScreen.main.bounds.width/4)
                }
            }
        }
    }
 
    
    @Published var indicatorOffset = -(UIScreen.main.bounds.width/4)
    
    //MARK: RESPONSIVE VALUE
    @Published var proxySize: CGSize = CGSize(width: 0, height: 0)
    
    var avatarSize : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 4.3 : proxySize.width / 4.3
    }
    var toolBarUserNameSize : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? 20 : 40
    }
    
    var toolBarSettingButtonSize : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? 20 : 40
    }
    
    var infoBlockSpacing : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? 15 : 20
    }
    
    var editButtonWidth : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width / 3.5 : proxySize.width / 4.3
    }
    
    var editButtonHeight : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.height/20 : proxySize.height/20
    }

    var buttonRadiusSize : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? 30 : proxySize.height/20
    }
    
    var plusButtonSize : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width/6 : proxySize.width/6
    }
    
    
    var tabButtonSize : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width/2 - 20 : proxySize.width/6
    }
    
    var tabIndicatorWidth : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? proxySize.width/2 - 10 : proxySize.width/6
    }
    
    var tabIconHeight : CGFloat{
        UIDevice.current.userInterfaceIdiom == .phone ? 30  : proxySize.width/6
    }
    
    @MainActor
    func fetchUserPosts(UserID: String) async throws {
        self.posts = try await APIService.fetchPostsOwned(byUserID: UserID)
    }
}
