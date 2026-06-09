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

    init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        dueDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.dueDate = dueDate
    }

    func isOverdue(now: Date = Date(), calendar: Calendar = .current) -> Bool {
        guard let dueDate else { return false }

        return !isCompleted &&
               !calendar.isDate(dueDate, inSameDayAs: now) &&
               dueDate < now
    }

    func matchesSearch(_ searchText: String) -> Bool {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else { return true }

        return title.localizedCaseInsensitiveContains(query) ||
               notes.localizedCaseInsensitiveContains(query)
    }
}
