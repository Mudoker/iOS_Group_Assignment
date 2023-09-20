//
//  CustomRoundedRec.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 17/09/2023.
//

import Foundation
import SwiftUI

struct RoundedCornerShape: Shape {
    var cornerRadius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        return Path(path.cgPath)
    }
}





