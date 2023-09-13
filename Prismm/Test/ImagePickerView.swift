//
//  SwiftUIView.swift
//  Prismm
//
//  Created by Ngoc Nguyen The Bao on 13/09/2023.
//

import SwiftUI

struct UIImagePickerView: UIViewControllerRepresentable{
    
    
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var isPresented: Bool
    @Binding var selectedMedia: NSURL?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        pickerController.mediaTypes = ["public.image", "public.movie"]
        
        return pickerController
    }
    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(media: $selectedMedia, isPresented: $isPresented)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
    }
}

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var media: NSURL?
    @Binding var isPresented: Bool
    
    init(media: Binding<NSURL?>, isPresented: Binding<Bool>) {
        self._media = media
        self._isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [UIImagePickerController.InfoKey : Any]) {
        print("set/chose image")
                
        
        if let mediaURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL {

            print(mediaURL)
            self.media = mediaURL
        }else {
            print("failed to get data")
        }
        
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
    
}


