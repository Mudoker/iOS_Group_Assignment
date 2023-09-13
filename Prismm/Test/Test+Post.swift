import SwiftUI
import PhotosUI
import AVKit

struct Test_UploadImg_Video: View {
    @StateObject var uploadVM = UploadPostViewModel()
    
    
//    @State private var image: UIImage?{
//        didSet{
//            Task{
//                await uploadVM.setSelected(image: image!)
//
//            }
//        }
//    }
    @State private var shouldPresentPickerSheet = false
    @State private var shouldPresentCamera = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(uploadVM.fetched_post) { post in
//                    Text(post.postCaption)
                    if let user = post.user {
                        Text(user.username)
                    }

                    if let mediaURL = URL(string: post.mediaURL ?? "") {
                        if let mimeType = post.mimeType {
                            if !mimeType.hasPrefix("image") {
                                // Handle video
                                let playerItem = AVPlayerItem(url: mediaURL)
                                let player = AVPlayer(playerItem: playerItem)
                                
                                VideoPlayer(player: player)
                                    .frame(height: 200)
                                    .onAppear {
                                        // Optionally, you can play the video when it appears on the screen.
                                        player.play()
                                    }
                            } else {
                                // Handle image
                                AsyncImage(url: mediaURL) { phase in
                                    switch phase {
                                    case .empty:
                                        // Placeholder while loading
                                        ProgressView()
                                    case .success(let image):
                                        // Image loaded successfully
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 200)
                                    case .failure(_):
                                        // Handle error, e.g., display a placeholder or error message
                                        Text("Image loading failed")
                                    @unknown default:
                                        // Handle other states if needed
                                        Text("Unknown state")
                                    }
                                }
                            }
                        } else {
                            // Handle the case where the mimeType is nil
                            Text("Invalid MIME type")
                        }
                    } else {
                        // Handle the case where the media URL is invalid or empty.
                        Text("Invalid media URL")
                    }
                }
            }
            .refreshable {
                Task {
                    try await uploadVM.fetchPost()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    

                    Button {
                        uploadVM.isAdding = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $shouldPresentPickerSheet) {
                        UIImagePickerView(sourceType: shouldPresentCamera ? .camera : .photoLibrary, isPresented: $shouldPresentPickerSheet, selectedMedia: $uploadVM.selectedMedia)
                    }
                            .actionSheet(isPresented: $uploadVM.isAdding) { () -> ActionSheet in
                                ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                                    self.shouldPresentPickerSheet = true
                                    self.shouldPresentCamera = true
                                }), ActionSheet.Button.default(Text("Photo Library"), action: {
                                    self.shouldPresentPickerSheet = true
                                    self.shouldPresentCamera = false
                                }), ActionSheet.Button.cancel()])
                            }
                        
                    }

                    
                
            }
        }
    }
}

struct Test_UploadImg_Video_Previews: PreviewProvider {
    static var previews: some View {
        Test_UploadImg_Video()
    }
}
