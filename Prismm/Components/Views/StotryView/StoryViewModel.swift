//
//  StoryViewModel.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 13/09/2023.
//

import Foundation
import SwiftUI

class StoryViewModel : ObservableObject {
    @Published var stories : [StoryBuddle] = [
        StoryBuddle(profileName: "Quang Anh", progfileImage: "test", stories: [
            Story(imageURL: "test"),
            Story(imageURL: "test2"),
            Story(imageURL: "test3"),
        ]),
         
        StoryBuddle(profileName: "Anh Tran", progfileImage: "test", stories: [
            Story(imageURL: "test"),
            Story(imageURL: "test2"),
            Story(imageURL: "test3"),
        ])
    ]
    
    @Published var showStory : Bool = false
    @Published var currentStory : String = ""
    
}
