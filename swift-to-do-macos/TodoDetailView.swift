//
//  TodoDetailView.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import SwiftData
import SwiftUI

struct TodoDetailView: View {
    @Bindable var item: Item

    var body: some View {
        Form {
            TextField("Title", text: $item.title)

            TextField("Notes", text: $item.notes, axis: .vertical)
                .lineLimit(4...10)

            Toggle("Completed", isOn: $item.isCompleted)
            
            Toggle("Has due date", isOn: Binding(
                    get: { item.dueDate != nil },
                    set: { item.dueDate = $0 ? Date() : nil }
                ))

            if item.dueDate != nil {
                    DatePicker(
                        "Due",
                        selection: Binding(
                            get: { item.dueDate ?? Date() },
                            set: { item.dueDate = $0 }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )
            }

            LabeledContent("Created") {
                Text(item.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .navigationTitle(item.title)
    }
}
