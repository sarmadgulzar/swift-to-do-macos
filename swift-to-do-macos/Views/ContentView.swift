//
//  ContentView.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Item.createdAt, order: .reverse)
    private var items: [Item]

    @State private var selectedItemID: UUID?
    @State private var newTodoTitle = ""
    @State private var filter: TodoFilter = .today
    @State private var searchText = ""
    @State private var isSearchPresented = false

    @FocusState private var focusedField: NewTodoBar.Field?

    var body: some View {
        NavigationSplitView {
            TodoSidebarView(
                items: items,
                selectedItemID: $selectedItemID,
                newTodoTitle: $newTodoTitle,
                filter: $filter,
                focusedField: $focusedField,
                searchText: searchText
            )
        } detail: {
            if let selectedItem {
                TodoDetailView(item: selectedItem)
            } else {
                Text("Select a todo")
                    .foregroundStyle(.secondary)
            }
        }
        .toolbar {
            Button {
                selectedItemID = nil
            } label: {
                Label("Unselect", systemImage: "xmark.circle")
            }
            .disabled(selectedItemID == nil)
            .keyboardShortcut(.cancelAction)

            Button {
                deleteSelectedItem()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .disabled(selectedItemID == nil)
        }
        .searchable(
            text: $searchText,
            isPresented: $isSearchPresented,
            prompt: "Search todos"
        )
        .focusedSceneValue(\.todoCommands, TodoCommands(
            createNewItem: focusNewTodoField,
            search: showSearch,
            selectFilter: selectFilter
        ))
    }

    private var selectedItem: Item? {
        guard let selectedItemID else { return nil }

        return items.first { item in
            item.id == selectedItemID
        }
    }

    private func focusNewTodoField() {
        newTodoTitle = ""
        focusedField = .title
    }

    private func showSearch() {
        isSearchPresented = true
    }

    private func selectFilter(_ newFilter: TodoFilter) {
        filter = newFilter
    }

    private func deleteSelectedItem() {
        guard let selectedItem else { return }

        withAnimation {
            modelContext.delete(selectedItem)
            selectedItemID = nil
        }
    }
}
