//
//  DropDownMenuOption.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 24/09/2023.
//


import Foundation

// We are going to use this type with ForEach, so we need to conform it to
// Hashable protocol.
struct DropdownMenuOption: Identifiable, Hashable {
    let id = UUID().uuidString
    var option: String
}

extension DropdownMenuOption {
    static let testSingleMonth: DropdownMenuOption = DropdownMenuOption(option: "March")
    static let testAllMonths: [DropdownMenuOption] = [
        DropdownMenuOption(option: "For you"),
        DropdownMenuOption(option: "Posts"),
        DropdownMenuOption(option: "People"),
    ]
}
