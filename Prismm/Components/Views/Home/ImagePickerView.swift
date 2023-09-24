//
//  SwiftUIView.swift
//  Prismm
//
//  Created by Ngoc Nguyen The Bao on 13/09/2023.
//

import SwiftUI

struct UIImagePickerView: UIViewControllerRepresentable{
    // Control state
    @Binding var isPresented: Bool
    @Binding var selectedMedia: NSURL?
    
    // Default source type for the image picker is the photo library.
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var allowVideos: Bool = true
    
    // Creates and configures a UIImagePickerController instance.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        
        if allowVideos {
            pickerController.mediaTypes = ["public.image", "public.movie"]
        }else{
            pickerController.mediaTypes = ["public.image"]
        }
        
        
        return pickerController
    }
    
    // Manage communication between the UIViewControllerRepresentable and UIKit UIImagePickerController.
    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(media: $selectedMedia, isPresented: $isPresented)
    }
    
    // Updates the UIImagePickerController when the SwiftUI view changes.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // Control state
    @Binding var media: NSURL?
    @Binding var isPresented: Bool
    
    // Initializes the coordinator with bindings to control state.
    init(media: Binding<NSURL?>, isPresented: Binding<Bool>) {
        self._media = media
        self._isPresented = isPresented
    }
    
    // Handles the event when an image or video is picked.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [UIImagePickerController.InfoKey : Any]) {
        print("set/chose image")
                
        // Check for media type and extract the media URL or image URL
        if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            print("get video")
            print(mediaURL)
            self.media = mediaURL
        }else if let mediaURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL {
            print("get image")
            print(mediaURL)
            self.media = mediaURL
        }else if let media = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // If it's an image -> save it to a temporary file and provide the file URL.
            guard let mediaURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TempImage.png") else { return }
            
            let mediaData = media.pngData()
            
            do {
                try mediaData?.write(to: mediaURL);
            } catch {}
            
            print("get camera")
            print(mediaURL)
            
            self.media = mediaURL as NSURL
            
            print(self.media as Any)
        } else {
            print("failed to get data")
        }
        
        // Dismiss the image picker.
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
}


