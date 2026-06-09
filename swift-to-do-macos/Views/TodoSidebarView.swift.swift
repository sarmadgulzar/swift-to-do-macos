//
//  TodoSidebarView.swift.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import SwiftData
import SwiftUI

struct TodoSidebarView: View {
    @Environment(\.modelContext) private var modelContext

    let items: [Item]

    @Binding var selectedItemID: UUID?
    @Binding var newTodoTitle: String
    @Binding var filter: TodoFilter

    let focusedField: FocusState<NewTodoBar.Field?>.Binding

    var searchText: String

    var body: some View {
        VStack {
            NewTodoBar(
                title: $newTodoTitle,
                onAdd: addItem,
                focusedField: focusedField
            )

            Picker("Filter", selection: $filter) {
                ForEach(TodoFilter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            .padding(.horizontal)

            List(selection: $selectedItemID) {
                ForEach(filteredItems) { item in
                    TodoRowView(
                        item: item,
                        isSelected: selectedItemID == item.id
                    )
                    .tag(item.id)
                }
                .onDelete(perform: deleteItems)
            }
        }
        .navigationTitle("Todos")
        .navigationSplitViewColumnWidth(min: 220, ideal: 260)
    }

    private var filteredItems: [Item] {
        items.filter { item in
            filter.matches(item) && item.matchesSearch(searchText)
        }
    }

    private func addItem() {
        let title = newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !title.isEmpty else { return }

        withAnimation {
            let newItem = Item(title: title)
            modelContext.insert(newItem)
            newTodoTitle = ""
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredItems[index])
            }
        }
    }
}
