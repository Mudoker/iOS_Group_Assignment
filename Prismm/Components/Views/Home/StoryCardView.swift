//
//  StoryCardView.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 13/09/2023.
//

import Foundation
import SwiftUI

struct StoryCardView: View {
    @Binding var bundle : StoryBuddle
    @EnvironmentObject var storyData : StoryViewModel
    @State var timer = Timer.publish(every: 0.1, on:  .main, in: .common).autoconnect()
    @State  var  timeProgress : CGFloat = 0
    var body: some View {
        GeometryReader { reader in
            //Stories
            ZStack{
                let index = min(Int(timeProgress), bundle.stories.count - 1)
                
                let story = bundle.stories[index] // double check lai
                Image(story.imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay(
                HStack{
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            if (timeProgress - 1) < 0{
                                updateStory(forward: false)
                            }
                            else{
                                timeProgress = CGFloat(Int(timeProgress -  1))
                            }
                        }
                    
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            if (timeProgress + 1) > CGFloat(bundle.stories.count){
                                updateStory()
                            }
                            else{
                                timeProgress = CGFloat(Int(timeProgress + 1))
                            }
                        }
                }
            )
            .rotation3DEffect(
                getAngle(reader: reader),
                axis: (x:0,y:1,z:0),
                anchor: reader.frame(in: .global).minX > 0 ? .leading : .trailing, perspective: 2.5
            )
            .overlay(
                HStack(spacing: 13){
                    Image(bundle.progfileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    
                    Text(bundle.profileName)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            storyData.showStory = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                    .padding(),
                alignment: .topTrailing
            )
            .overlay(
                HStack(spacing: 5) {
                    ForEach(bundle.stories.indices) { index in
                        
                        GeometryReader { reader in
                            let width = reader.size.width
                            let progress = timeProgress - CGFloat(index)
                            let perfectProgress = min(max(progress,0),1)
                            
                            Capsule()
                                .fill(.gray.opacity(0.5))
                                .overlay(
                                    Capsule()
                                        .fill(.white)
                                        .frame(width: width *  perfectProgress)
                                    
                                    , alignment: .leading
                                )
                        }
                    }
                }
                    .frame(height: 1.4)
                    .padding(.horizontal)
                
                ,alignment : .top
                
                
            )
            .rotation3DEffect(
                getAngle(reader: reader),
                axis: (x:0,y:1,z:0),
                anchor: reader.frame(in: .global).minX > 0 ? .leading : .trailing, perspective: 2.5
            )
        }
        .onAppear(perform: {
            timeProgress = 0
        })
        .onReceive(timer){ _ in
            if (storyData.currentStory == bundle.id){
                if (!bundle.isSeen){
                    bundle.isSeen = true
                }
                
                if (timeProgress < CGFloat(bundle.stories.count)){
                    timeProgress += 0.03
                }else{
                    updateStory()
                }
            }
        }
    }
    func updateStory(forward : Bool = true){
        let index = min(Int(timeProgress), bundle.stories.count - 1)
        let story = bundle.stories[index]
        if (!forward){
            if let first =  storyData.stories.first, first.id != bundle.id{
                let bundleIndex = storyData.stories.firstIndex{ currBundle in
                    return bundle.id == currBundle.id
                } ?? 0
                
                withAnimation{
                    storyData.currentStory = storyData.stories[bundleIndex - 1 ].id
                }
            }
            else{
                timeProgress =  0 
            }
            
        }
        if let last = bundle.stories.last, last.id == story.id{
            if let lastBundle = storyData.stories.last, lastBundle.id == bundle.id{
                withAnimation{
                    storyData.showStory = false
                }
                timeProgress = 0
            }
            else{
                let bundleIndex = storyData.stories.firstIndex { currBundle in
                    return bundle.id == currBundle.id
                } ?? 0
                
                withAnimation{
                    storyData.currentStory = storyData.stories[bundleIndex + 1 ].id
                }
            }
        }
    }
    
    func getAngle(reader : GeometryProxy) -> Angle{
        let progress = reader.frame(in: .global).minX / reader.size.width
        
        let rotationAngle : CGFloat = 45
        let degrees = rotationAngle * progress
        
        return Angle(degrees: Double(degrees))
    }
}

//struct StoryCardView_Previews : PreviewProvider {
//    static var previews: some View{
//        StoryCardView()
//    }
//}

