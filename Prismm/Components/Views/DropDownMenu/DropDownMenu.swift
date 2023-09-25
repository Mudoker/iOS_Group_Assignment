//
//  DropDownMenu.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 24/09/2023.
//

import Foundation

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
