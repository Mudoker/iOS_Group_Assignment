//
//  UploadPostViewModel.swift
//  Prismm
//
//  Created by Nguyen Dinh Viet on 12/09/2023.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase

class UploadPostViewModel: ObservableObject {
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task {
                await loadImage(fromItem: selectedImage)
            }
        }
    }
    @Published var postImage: Image?
    private var uiImage: UIImage?
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else {return}
        guard let data = try? await item.loadTransferable(type: Data.self) else {return}
        guard let uiImage = UIImage(data:data) else {return}
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
    }
    
    func uploadingPost(caption: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let uiImage = uiImage else {return}
        let post = Post(id: "", owner: uid, postCaption: caption, likers: [], postImage: "", Date: <#T##Date#>)
    }
}
