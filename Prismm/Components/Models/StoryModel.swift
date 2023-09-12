//
//  StoryModel.swift
//  Prismm
//
//  Created by Quoc Doan Huu on 09/09/2023.
//

import Foundation

struct Story {
    let id: UUID
    let date: Date
    var status: Bool
    var source: URL
    let op: [UUID]
    var likers: [UUID]
}
