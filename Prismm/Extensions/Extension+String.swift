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
    // check for sepecial characters
    func containsSpecialSymbols() -> Bool {
        let specialSymbols = CharacterSet(charactersIn: "!@#$%^&*()-_=+[]{}|;:'\",.<>?/`~")
        return self.rangeOfCharacter(from: specialSymbols) != nil
    }
    
    // validate url
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
    
    // Extract the name from an email address
    func extractNameFromEmail() -> String? {
        // Split the email at the "@" symbol
        let components = self.components(separatedBy: "@")
        // Check if there are at least two components (name and domain)
        if components.count >= 2 {
            return components[0] // The name is the first component
        } else {
            return nil // Invalid email format
        }
    }
}
