//
//  NewTodoBar.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import SwiftUI

struct NewTodoBar: View {
    @Binding var title: String
    let onAdd: () -> Void

    enum Field {
        case title
    }

    let focusedField: FocusState<Field?>.Binding

    var body: some View {
        HStack {
            TextField("New todo", text: $title)
                .textFieldStyle(.roundedBorder)
                .focused(focusedField, equals: .title)
                .onSubmit(onAdd)

            Button {
                onAdd()
            } label: {
                Image(systemName: "plus")
            }
            .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }
}
