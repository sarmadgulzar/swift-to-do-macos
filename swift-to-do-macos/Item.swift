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
    var id: UUID
    var title: String
    var notes: String
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date?



    init(id: UUID = UUID(), title: String, notes: String = "", isCompleted: Bool = false, createdAt: Date = Date(), dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.dueDate = dueDate
    }
}
