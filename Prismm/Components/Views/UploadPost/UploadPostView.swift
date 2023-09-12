////
////  UploadPostView.swift
////  Prismm
////
////  Created by Nguyen Dinh Viet on 12/09/2023.
////
//
//import Foundation
//import SwiftUI
//import PhotosUI
//import AVFoundation
//import MobileCoreServices
//import Firebase
//
//struct UploadPostView: View {
//    @State private var caption = ""
//    @State private var imagePickerPresented = false
//    @StateObject var viewModel = UploadPostViewModel()
//    var body: some View {
//        VStack {
//            HStack {
//                Button {
//                    //
//                } label: {
//                    Text("Cancel")
//                }
//                
//                
//                Spacer()
//                
//                Text("New Post")
//                    .fontWeight(.semibold)
//                
//                Spacer()
//                
//                Button {
//                    print("Upload")
//                } label: {
//                    Text("Upload")
//                        .fontWeight(.semibold)
//                }
//            }
//                .padding(.horizontal)
//            
//            HStack {
//                if let image = viewModel.postImage {
//                    image
//                        .resizable()
//                        .frame(width: 100, height: 100)
//                }
//                
//                TextField("Enter your caption", text: $caption, axis:.vertical)
//            }.padding()
//            Spacer()
//        }.onAppear {
//            imagePickerPresented.toggle()
//        }
//        .photosPicker(isPresented: $imagePickerPresented, selection: $viewModel.selectedImage)
//    }
//}
//
//
//struct UploadPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        UploadPostView()
//    }
//}
