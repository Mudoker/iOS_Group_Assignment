/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Apple Men
 Doan Huu Quoc (s3927776)
 Tran Vu Quang Anh (s3916566)
 Nguyen Dinh Viet (s3927291)
 Nguyen The Bao Ngoc (s3924436)
 
 Created  date: 10/09/2023
 Last modified: 10/09/2023
 Acknowledgement: None
 */

import Foundation

extension String {
    func containsSpecialSymbols() -> Bool {
        let specialSymbols = CharacterSet(charactersIn: "!@#$%^&*()-_=+[]{}|;:'\",.<>?/`~")
        return self.rangeOfCharacter(from: specialSymbols) != nil
    }
    
    func isValidURL(forPlatform platform: String) -> Bool {
        // Return false for empty profile URLs
        guard !self.isEmpty else {
            return false
        }
        
        switch platform {
        case "fb":
            return self.hasPrefix("https://www.facebook.com/")
        case "ld":
            return self.hasPrefix("https://www.linkedin.com/")
        case "gm":
            let gmailRegex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9._%+-]+@gmail\\.com")
            let range = NSRange(location: 0, length: self.utf16.count)
            return gmailRegex.firstMatch(in: self, options: [], range: range) != nil
        default:
            return false // Not supported platform
        }
    }
}
