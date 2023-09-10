//
//  Extension+String.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 08/09/2023.
//

import Foundation

extension String {
    func containsSpecialSymbols() -> Bool {
        let specialSymbols = CharacterSet(charactersIn: "!@#$%^&*()-_=+[]{}|;:'\",.<>?/`~")
        return self.rangeOfCharacter(from: specialSymbols) != nil
    }
}
