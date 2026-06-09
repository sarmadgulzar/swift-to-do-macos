//
//  TodoCommands.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import SwiftUI

struct TodoCommands {
    var createNewItem: () -> Void
    var search: () -> Void
    var selectFilter: (TodoFilter) -> Void
}

private struct TodoCommandsKey: FocusedValueKey {
    typealias Value = TodoCommands
}

extension FocusedValues {
    var todoCommands: TodoCommands? {
        get { self[TodoCommandsKey.self] }
        set { self[TodoCommandsKey.self] = newValue }
    }
}

struct TodoCommandButton: View {
    @FocusedValue(\.todoCommands) private var commands

    let title: String
    let shortcut: KeyEquivalent
    let action: (TodoCommands) -> Void

    var body: some View {
        Button(title) {
            guard let commands else { return }
            action(commands)
        }
        .keyboardShortcut(shortcut, modifiers: .command)
        .disabled(commands == nil)
    }
}
