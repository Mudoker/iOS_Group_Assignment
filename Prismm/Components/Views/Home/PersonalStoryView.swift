//
//  PersonalStoryView.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 13/09/2023.
//

import Foundation
import SwiftUI

struct PersonalStoryView: View {
    @EnvironmentObject var storyData : StoryViewModel
    var body: some View {
        GeometryReader {reader in
            //Stories
            if (storyData.showStory == true){
                TabView(selection: $storyData.currentStory){
                    ForEach($storyData.stories){ $bundle in
                        StoryCardView(bundle: $bundle)
                            .environmentObject(storyData)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxWidth: .infinity, maxHeight: .infinity )
                .background(.black)
                
                //transition
                .transition(.move(edge: .bottom))
            }
        }
    }
}


struct PersonalStoryView_Previews : PreviewProvider {
    static var previews: some View{
        PersonalStoryView()
    }
}
