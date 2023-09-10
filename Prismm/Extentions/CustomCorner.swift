//
//  CustomCorner.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 10/09/2023.
//
import Foundation
import SwiftUI

struct CustomCorners : Shape{
    var corners : UIRectCorner
    var radius : CGFloat
    
    func path(in rect : CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
