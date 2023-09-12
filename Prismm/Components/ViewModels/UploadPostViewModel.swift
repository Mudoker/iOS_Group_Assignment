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
import FirebaseStorage
import MobileCoreServices
import AVFoundation
import FirebaseFirestoreSwift

class UploadPostViewModel: ObservableObject {
    @Published var fetched_images = [Post_Image]()
    @Published var fetched_videos = [Post_Video]()

    @Published var selectedMedia: PhotosPickerItem? {
        didSet {
            Task {
                try await uploadMediaFromLocal()
            }
        }
    }
    
    init() {
        Task {
            try await fetchMedia()
        }
    }
    
    @Published var postImage: Image?
    @Published var selectedVideoURL: URL? // Store the video URL

    func uploadMediaFromLocal() async throws {
        guard let media = selectedMedia else { return }
        
        guard let mediaData = try await media.loadTransferable(type: Data.self) else { return }
        
        if mediaData.count > 25_000_000 {
            print("Selected file too large: \(mediaData)")
        } else {
            print("Approved: \(mediaData)")
        }
        
        guard let mediaUrl = try await uploadMediaToFireBase(data: mediaData) else { return }
        
        if mimeType(for: mediaData) == "video/avi" || mimeType(for: mediaData) == "video/mp4" || mimeType(for: mediaData) == "video/quicktime" || mimeType(for: mediaData) == "video/webm" {
            try await Firestore.firestore().collection("post_videos").document().setData(["mediaUrl" : mediaUrl, "type" : mimeType(for: mediaData)])
        } else {
            try await Firestore.firestore().collection("post_images").document().setData(["mediaUrl" : mediaUrl, "type" : mimeType(for: mediaData)])
        }
        
        print (" load ok ")
    }
    
    func uploadMediaToFireBase(data: Data) async throws -> String? {
        let fileName = UUID().uuidString
        var ref = Storage.storage().reference().child("/medias/\(fileName)")

        if mimeType(for: data) == "video/avi" || mimeType(for: data) == "video/mp4" || mimeType(for: data) == "video/quicktime" || mimeType(for: data) == "video/webm" {
            ref = Storage.storage().reference().child("/post_videos/\(fileName)")
        } else {
            ref = Storage.storage().reference().child("/post_images/\(fileName)")
        }
        
        let metaData  = StorageMetadata()
        metaData.contentType = mimeType(for: data)
        
        do {
            let _ = try await ref.putDataAsync(data, metadata: metaData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("Media upload failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    @MainActor
    func fetchMedia() async throws {
        let images = try await Firestore.firestore().collection("post_images").getDocuments()
        let videos = try await Firestore.firestore().collection("post_videos").getDocuments()
        
        self.fetched_images = images.documents.compactMap { document in
            do {
                return try document.data(as: Post_Image.self)
            } catch {
                print("Error decoding document: \(error)")
                return nil
            }
        }
        
        self.fetched_videos = videos.documents.compactMap { document in
            do {
                return try document.data(as: Post_Video.self)
            } catch {
                print("Error decoding document: \(error)")
                return nil
            }
        }
        
        for each in images.documents {
            print(each)
        }
    }
    
    func uploadingPost(caption: String) async throws {

    }
    
    func mimeType(for data: Data) -> String {
        var b: UInt8 = 0
        data.copyBytes(to: &b, count: 1)

        switch b {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x4D, 0x49:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        // Check for common video file formats
        case 0x52:
            // Check for "RIFF" which is a common header in AVI files
            if data.count >= 12 && data[8...11] == Data("AVI ".utf8) {
                return "video/avi"
            }
        case 0x00:
            // Check for video formats like MP4
                   if data.count >= 12 && data[4...7] == Data("ftyp".utf8) {
                       return "video/mp4"
                   }
            
           // Check for MOV format
           if data.count >= 4 && data[4...7] == Data("ftyp".utf8) && data[8...11] == Data("qt  ".utf8) {
               return "video/quicktime"
           }
        case 0x1A:
            // Check for video formats like MKV
            if data.count >= 4 && data[1...3] == Data("webm".utf8) {
                return "video/webm"
            }
        // Add more checks for specific file formats here
        default:
            return "application/octet-stream"
        }

        return "application/octet-stream"
    }
}
