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

  Created  date: 09/09/2023
  Last modified: 09/09/2023
  Acknowledgement: None
*/

import Foundation
import SwiftUI

class FollowViewModel: ObservableObject{
    @Published var followerList = ["testAvt","testAvt","testAvt","testAvt","testAvt"]
    
    @Published var searchText = ""
    @Published var tabSelection = 1{
        didSet{
            switch tabSelection{
            case 1:
                withAnimation {
                    indicatorOffset = -(UIScreen.main.bounds.width/4)
                }
                
            case 2:
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
    @Published var isDarkMode = true{
        didSet{
            if isDarkMode {
                colorTheme = Constants.darkThemeColor
            }else{
                colorTheme = Constants.lightThemeColor
            }
        }
    }
    
    
    @Published var colorTheme = Constants.darkThemeColor
    let userNameFontSize = UIDevice.current.userInterfaceIdiom == .phone ? 20 : 32
    let tabNameFontSize = UIDevice.current.userInterfaceIdiom == .phone ? 18 : 24
    let searchTextFontSize = UIDevice.current.userInterfaceIdiom == .phone ? 20 : 24
    let rowUserNameFontSize = UIDevice.current.userInterfaceIdiom == .phone ? 20 : 24
    let rowBioFontSize = UIDevice.current.userInterfaceIdiom == .phone ? 16 : 20
    let rowButtonFontSize = UIDevice.current.userInterfaceIdiom == .phone ? 18 : 22
    
    
    func trueIsShowing() {
        withAnimation {
            tabSelection = 1
        }
        
    }
    
    func falseIsShowing() {
        withAnimation {
            tabSelection = 2
        }
    }
    
    func changeTheme(isDarkMode: Bool) {
        self.isDarkMode = isDarkMode
    }
}
