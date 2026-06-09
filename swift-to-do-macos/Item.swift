//
//  Item.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var title: String
    var notes: String
    var isCompleted: Bool
    var createdAt: Date



    init(title: String, notes: String = "", isCompleted: Bool = false, createdAt: Date = Date()) {
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
