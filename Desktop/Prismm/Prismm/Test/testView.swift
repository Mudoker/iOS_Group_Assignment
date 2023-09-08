//
//  test3.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import Foundation

import SwiftUI

struct ThreeDButton: View {
    let label: String

    var body: some View {
        Button(action: {}) {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
                .padding(10)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                )
        }
    }
}

struct testView: View {
    var body: some View {
        HStack(){
            VStack{
                
            }
            .frame(width: 20)
           Image("logoText")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .alignmentGuide(.trailing) { dimension in
            dimension[.trailing]
        }
        .frame(width: 150, height: 150, alignment: .bottom)
        .background(.red)
        .ignoresSafeArea()
    }
}

struct test_Preview :  PreviewProvider {
    static var previews: some View {
        testView()
    }
}

