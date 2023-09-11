//
//  ContentView.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

import SwiftUI

struct ContentView: View {
    @State private var isTextVisible = true

    var body: some View {
        GeometryReader{ geometry in
            VStack {
                if isTextVisible {
                    Text("This is a toggleable text.")
                        .font(.largeTitle)
                        .padding()
                }
                
                Button(action: {
                    print(geometry.size.width)
                }) {
                    Text(isTextVisible ? "Hide Text" : "Show Text")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
