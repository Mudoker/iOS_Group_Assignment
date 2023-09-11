//
//  PersonalChat.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 10/09/2023.
//

import Foundation
import SwiftUI


struct PersonalChat: View {
    @State private var searchTerm : String = ""
    var body: some View {
        NavigationStack{
            GeometryReader{ geometry in
                VStack(){
                    VStack{
                        
                    }
                    .frame(height: 5)
                    ScrollView(.vertical){
                        LazyVStack{
                            
                        }
                    }
                    .frame(height: 650)
                    .background(.black)
                    Spacer()
                    VStack {
                        HStack {
                            Image(systemName: "mic")
                                .foregroundColor(.gray)
                            TextField("Type here", text: $searchTerm)
                                .foregroundColor(.black)
                            Image(systemName: "photo.on.rectangle.angled")
                                .foregroundColor(.gray)
                            Image(systemName: "face.smiling")
                                .foregroundColor(.gray)
                            
                        }
                        
                        .frame(height: 40)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20)
                    }
                    .padding(.horizontal,10)
                }
                .padding(.horizontal,10)
                
                
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 0){
                        Button{
                            
                        } label : {
                            Image(systemName: "arrow.left")
                        }
                        
                        HStack(spacing: 15){
                            Image("sample_avatar")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width : 45, height : 45)
                                .mask(Circle())
                            VStack(alignment: .leading){
                                Text("Quoc Doan")
                                    .fontWeight(.bold)
                                Text("Online")
                            }
                        }
                    }
                    .padding(8)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
        }
    }
}


struct PersonalChat_Previews: PreviewProvider {
    static var previews: some View {
        PersonalChat()
    }
}

