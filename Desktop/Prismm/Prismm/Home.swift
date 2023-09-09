//
//  Home.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 08/09/2023.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    var body: some View {
        GeometryReader {reader in
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack (spacing: 40) {
                            StoryView()
                                .frame(width: reader.size.width * 0.2,height: reader.size.height * 0.14)
                            StoryView()
                                .frame(width: reader.size.width * 0.2,height: reader.size.height * 0.14)
                            
                            StoryView()
                                .frame(width: reader.size.width * 0.2,height: reader.size.height * 0.14)
                            
                            StoryView()
                                .frame(width: reader.size.width * 0.2,height: reader.size.height * 0.14)
                            
                            StoryView()
                                .frame(width: reader.size.width * 0.2,height: reader.size.height * 0.14)
                        }
                        .padding(.top, reader.size.height * 0.01)
                        .padding(.horizontal, reader.size.width * 0.03)
                    }
                    
                    Divider()
                    VStack {
                        PostView()
                            .frame(height: reader.size.height)
                        
                        PostView()
                            .frame(height: reader.size.height)
                        
                        PostView()
                            .frame(height: reader.size.height)
                    }.padding(.top, reader.size.height * 0.01)
                }
                .navigationBarTitle("", displayMode: .inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigation) {
                        Image("instagram")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 130)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                          NavigationLink(destination: EmptyView()) {
                                Image(systemName: "message")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: min(reader.size.width, reader.size.height) * 0.06)
                            }
                    }
                })
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
