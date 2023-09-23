////
////  DropdownMenu.swift
////  Prismm
////
////  Created by Tran Vu Quang Anh  on 23/09/2023.
////
//
//import Foundation
//
//import SwiftUI
//
//struct DropdownMenu: View {
//    /// Used to show or hide drop-down menu options
//    @State private var isOptionsPresented: Bool = false
//
//    /// Used to bind user selection
//    @Binding var selectedOption: DropdownMenuOption?
//
//    /// A placeholder for drop-down menu
//    let placeholder: String
//
//    /// The drop-down menu options
//    let options: [DropdownMenuOption]
//
//    var body: some View {
//        Button(action: {
//            withAnimation(.easeIn(duration: 0.3)) {
//                self.isOptionsPresented.toggle()
//            }
//        }) {
//            HStack {
//                Text(selectedOption == nil ? placeholder : selectedOption!.option)
//                    .fontWeight(.medium)
//                    .foregroundColor(selectedOption == nil ? .gray : .black)
//
//                Spacer()
//
//                Image(systemName: self.isOptionsPresented ? "chevron.up" : "chevron.down")
//                    // This modifier available for Image since iOS 16.0
//                    .fontWeight(.medium)
//                    .foregroundColor(.black)
//            }
//        }
//        .padding()
//        .overlay {
//            RoundedRectangle(cornerRadius: 5)
//                .stroke(.gray, lineWidth: 2)
//        }
//        .overlay(alignment: .top) {
//            VStack {
//                if self.isOptionsPresented {
//                    Spacer(minLength: 60)
//                    DropdownMenuList(options: self.options) { option in
//                        withAnimation(.easeIn(duration: 0.3)){
//                            self.isOptionsPresented = false
//                            self.selectedOption = option
//                        }                    }
//                }
//            }
//        }
//        .padding(.horizontal)
//        // We need to push views under drop down menu down, when options list is
//        // open
//        .padding(
//            // Check if options list is open or not
//            .bottom, self.isOptionsPresented
//            // If options list is open, then check if options size is greater
//            // than 300 (MAX HEIGHT - CONSTANT), or not
//            ? CGFloat(self.options.count * 32) > 300
//                // IF true, then set padding to max height 300 points
//                ? 300 + 30 // max height + more padding to set space between borders and text
//                // IF false, then calculate options size and set padding
//                : CGFloat(self.options.count * 32) + 30
//            // If option list is closed, then don't set any padding.
//            : 0
//        )
//    }
//}
//
//struct DropdownMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        DropdownMenu(
//            selectedOption: .constant(nil),
//            placeholder: "Enter",
//            options: DropdownMenuOption.testAllMonths
//        )
//    }
//}

//
//  DropdownMenu.swift
//  DropdownMenu
//
//  Created by Abdelrahman Talaat on 28/11/2022.
//

import SwiftUI

struct DropdownMenu: View {
    /// Used to show or hide drop-down menu options
    @State private var isOptionsPresented: Bool = false
    
    /// Used to bind user selection
    @Binding var selectedOption: DropdownMenuOption?
    
    /// A placeholder for drop-down menu
    let placeholder: String
    
    /// The drop-down menu options
    let options: [DropdownMenuOption]
    
    var body: some View {
        Button(action: {
            withAnimation(.easeIn(duration: 0.3)) {
                self.isOptionsPresented.toggle()
            }
        }) {
            HStack {
                Text(selectedOption == nil ? placeholder : selectedOption!.option)
                    .fontWeight(.medium)
                    .foregroundColor(selectedOption == nil ? .gray : .black)
                
                
                Image(systemName: self.isOptionsPresented ? "chevron.up" : "chevron.down")
                    // This modifier available for Image since iOS 16.0
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            }
            .frame(width: 120)
//            .padding(.horizontal,20)
        }
        .padding(.vertical,5)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray, lineWidth: 2)
                .frame(width: 100)
        }
        .overlay(alignment: .top) {
            VStack {
                if self.isOptionsPresented {
                    Spacer(minLength: 35)
                    DropdownMenuList(options: self.options) { option in
                        withAnimation(.easeIn(duration: 0.3)){
                            self.isOptionsPresented = false
                            self.selectedOption = option
                        }
                    }
                }
            }
        }
//        .padding(.horizontal)
        .padding(
            .bottom, self.isOptionsPresented
            ? CGFloat(self.options.count * 32) > 300
                ? 300 + 30
                : CGFloat(self.options.count * 32) + 30
            : 0
        )
//        .background(.red)
    }
}

struct DropdownMenu_Previews: PreviewProvider {
    static var previews: some View {
        DropdownMenu(
            selectedOption: .constant(nil),
            placeholder: "For you",
            options: DropdownMenuOption.testAllMonths
        )
    }
}
