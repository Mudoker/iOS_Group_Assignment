//
//  BlockListRow.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 23/09/2023.
//

import SwiftUI
import Kingfisher

struct BlockListRow: View {
    let user: User
    @ObservedObject var blockVM: BlockViewModel
    var body: some View {
        HStack{

            if user.profileImageURL != "" {
                KFImage(URL(string: user.profileImageURL ?? ""))
                    .resizable()
                    .frame(width: 50 , height: 50)
                    .clipShape(Circle())
                    .background(Circle().foregroundColor(Color.gray))
            

            } else {
                // Handle the case where the media URL is invalid or empty.
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                
            }
            
            Text(user.username)
            
            Spacer()
            Button {
                
                Task{
                    var removeIndex = 0
                    try await APIService.unblockOtherUser(forUserID: user.id)
                    
                    
                    for index in blockVM.userBlockList.indices{
                        if blockVM.userBlockList[index].id == user.id{
                            removeIndex = index
                        }
                    }
                    
                    withAnimation {
                        blockVM.userBlockList.remove(at: removeIndex)
                    }
                }
                
                
                
            } label: {
                Text("Unblock")
                    .foregroundColor(.red)
                    .frame(width: 100, height: 30)
                    .background{
                        Color.gray
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
            }

        }
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

struct BlockListRow_Previews: PreviewProvider {
    static var previews: some View {
        BlockListRow(user: User(id: "1", account: "ngoc"), blockVM: BlockViewModel())
    }
}

