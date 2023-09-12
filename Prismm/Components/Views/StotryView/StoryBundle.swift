//
//  StoryBundle.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 12/09/2023.
//

import Foundation
import SwiftUI

struct StoryBuddle: Identifiable, Hashable {
    var id  = UUID().uuidString
    var profileName : String
    var progfileImage : String
    var isSeen : Bool = false
    var stories : [Story]
}

struct Story : Identifiable, Hashable {
    var id = UUID().uuidString
    var imageURL : String
}

