//
//  TodoFilter.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import Foundation

enum TodoFilter: String, CaseIterable, Identifiable {
    case overdue = "Overdue"
    case today = "Today"
    case upcoming = "Upcoming"
    case someday = "Someday"
    case done = "Done"

    var id: Self { self }

    func matches(_ item: Item, now: Date = Date(), calendar: Calendar = .current) -> Bool {
        switch self {
        case .overdue:
            guard let dueDate = item.dueDate else { return false }

            return !item.isCompleted &&
                   !calendar.isDate(dueDate, inSameDayAs: now) &&
                   dueDate < now

        case .today:
            guard let dueDate = item.dueDate else { return false }

            return !item.isCompleted &&
                   calendar.isDate(dueDate, inSameDayAs: now)

        case .upcoming:
            guard let dueDate = item.dueDate else { return false }

            return !item.isCompleted &&
                   !calendar.isDate(dueDate, inSameDayAs: now) &&
                   dueDate > now

        case .someday:
            return !item.isCompleted && item.dueDate == nil

        case .done:
            return item.isCompleted
        }
    }
}
