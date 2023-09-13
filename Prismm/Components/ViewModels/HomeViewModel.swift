//
//  HomeViewModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    // Responsive
    @Published var storyViewSizeWidth: CGFloat = 0
    @Published var storyViewSizeHeight: CGFloat = 0
    @Published var appLogoSize: CGFloat = 0
    @Published var messageLogoSize: CGFloat = 0
    @Published var profileImageSize: CGFloat = 0
    @Published var usernameFont: CGFloat = 20
    @Published var seeMoreButtonSize: CGFloat = 0
    @Published var captionFont: Font = .title3
    @Published var postStatsFontSize: CGFloat = 0
    @Published var postStatsImageSize: CGFloat = 0
    @Published var commentProfileImage: CGFloat = 0
    @Published var commentTextFieldSizeHeight: CGFloat = 0
    @Published var commentTextFiledFont: Font = .caption
    @Published var commentTextFieldRoundedCorner: CGFloat = 15
}
