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

  Created  date: 08/09/2023
  Last modified: 08/09/2023
  Acknowledgement: None
*/

import Foundation
import SwiftUI

struct Constants {
    static var currentUserID = ""
    static let darkThemeColor: Color = Color(red: 0.16, green: 0.67, blue: 0.53)
    static let lightThemeColor: Color = Color.pink
    static let buttonGradientColorDark: [Color] = [Color(red: 0.27, green: 1.00, blue: 0.79), Color(red: 0.59, green: 1.00, blue: 0.96), Color(red: 0.44, green: 0.57, blue: 0.96)]
    static let buttonGradientColorLight: [Color] = [Color(red: 0.96, green: 0.51, blue: 0.65), Color(red: 0.95, green: 0.00, blue: 0.53), Color(red: 0.44, green: 0.10, blue: 0.46)]
    static let lightThemeAppLogo = "logolight"
    static let darkThemeAppLogo = "logodark"
    static let storyGradientBorder = Gradient(colors: [.yellow, .red, .purple, .orange, .pink, .red])
    static let availableTags = ["Wonders", "Technology", "Education", "Trivial", "Personal", "FYP", "Documentation", "Engineering", "Business", "Gaming", "Ask"]
}
