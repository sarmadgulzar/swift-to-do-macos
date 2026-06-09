//
//  TodoRowView.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import SwiftUI

struct TodoRowView: View {
    let item: Item
    let isSelected: Bool

    var body: some View {
        HStack {
            Button {
                item.isCompleted.toggle()
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .white : .secondary)
            }
            .buttonStyle(.plain)

            Text(item.title)
                .strikethrough(item.isCompleted)
                .foregroundStyle(titleColor)
        }
    }

    private var titleColor: Color {
        if isSelected {
            return .white
        }

        if item.isCompleted {
            return .secondary
        }

        if item.isOverdue() {
            return .red
        }

        return .primary
    }
}
