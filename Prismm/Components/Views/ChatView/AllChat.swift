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
//
//  SplashScreen.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 08/09/2023.
//

import Foundation
import SwiftUI

struct AllChat : View {
    @State var searchTerm : String = ""
    @State var searchState : Bool = true
    @State var selected : Int = 0
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                ScrollView(.vertical){
                    LazyVStack{
                        VStack (spacing: 10){
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                TextField("Search", text: $searchTerm)
                                    .foregroundColor(.black)
                                
                                Button(action: {
                                    
                                    withAnimation(.spring()) {
                                        
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                
                            }
                            .frame(width: geometry.size.width - 35, height: 25)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .opacity(searchState ? 1 : 0) // Toggle opacity based on searchState
                            
                            ScrollView(.horizontal){
                                LazyHStack{
                                    UserActiveChat()
                                        .padding(.horizontal,10)
                                    UserActiveChat()
                                        .padding(.horizontal,10)
                                    UserActiveChat()
                                        .padding(.horizontal,10)
                                    UserActiveChat()
                                        .padding(.horizontal,10)
                                    UserActiveChat()
                                        .padding(.horizontal,10)
                                    UserActiveChat()
                                        .padding(.horizontal,10)
                                    UserActiveChat()
                                        .padding(.horizontal,10)
                                    UserActiveChat()
                                        .padding(.horizontal,10)
                                }
                                .frame(height: 130)
                            }
                            
                            //Message
                            VStack(spacing: 15){
                                HStack{
                                    Button{
                                        self.selected = 0
                                    } label: {
                                        Text("Message")
                                            .foregroundColor(.black)
                                            .font(.footnote)
                                            .frame(width: 70)
                                            .padding(.vertical,12)
                                            .padding(.horizontal,10)
                                            .background(self.selected == 0 ? Color.blue : Color.white)
                                            .clipShape(Capsule())
                                    }
                                    
                                    Button{
                                        self.selected = 1
                                    } label: {
                                        Text("Request")
                                            .foregroundColor(.black)
                                            .font(.footnote)
                                            .frame(width: 70)
                                            .padding(.vertical,12)
                                            .padding(.horizontal,10)
                                            .background(self.selected == 1 ? Color.blue : Color.white)
                                            .clipShape(Capsule())
                                        
                                        
                                    }
                                }
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Capsule())
                                
                                // Message List
                                LazyVStack(spacing: 12){
                                    PreviewUserChat()
                                    PreviewUserChat()
                                    PreviewUserChat()
                                    PreviewUserChat()
                                    PreviewUserChat()
                                    PreviewUserChat()
                                    PreviewUserChat()
                                    PreviewUserChat()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        //                    .offset(x: searchState ? -60 : 300, y: 70)
                        
                        
                    }
                    .padding(.horizontal,190)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack(spacing: 25){
                                Button{
                                    
                                } label : {
                                    Image(systemName: "arrow.left")
                                }
                                HStack(spacing: 10){
                                    Text("tranvuquanganh87")
                                    VStack{
                                        Image(systemName: "chevron.down")
                                            .scaleEffect(0.6)
                                    }
                                    .frame(width: 5, height: 5)
                                    
                                }
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            
                        }
                    }
                }
            }
        }
    }
}

struct AllChat_Previews: PreviewProvider {
    static var previews: some View {
        AllChat()
    }
}
