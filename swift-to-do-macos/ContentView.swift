//
//  ContentView.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import SwiftData
import SwiftUI

enum TodoFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"

    var id: Self { self }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Item.createdAt, order: .reverse)
    private var items: [Item]

    @State private var newTodoTitle = ""
    @State private var selectedItem: Item?
    @State private var filter: TodoFilter = .all

    var body: some View {
        NavigationSplitView {
            VStack {
                HStack {
                    TextField("New todo", text: $newTodoTitle)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                                addItem()
                            }

                    Button {
                        addItem()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                
                Picker("Filter", selection: $filter) {
                    ForEach(TodoFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List(selection: $selectedItem) {
                    ForEach(filteredItems) { item in
                        HStack {
                            Button {
                                item.isCompleted.toggle()
                            } label: {
                                Image(
                                    systemName: item.isCompleted
                                        ? "checkmark.circle.fill" : "circle")
                            }
                            .buttonStyle(.plain)

                            Text(item.title)
                                .strikethrough(item.isCompleted)
                                .foregroundStyle(item.isCompleted ? .secondary : .primary)
                        }
                        .tag(item)
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Todos")
            .navigationSplitViewColumnWidth(min: 220, ideal: 260)
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
                deleteSelectedItem()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .disabled(selectedItem == nil)
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
    
    private func deleteSelectedItem() {
        guard let selectedItem else { return }

        withAnimation {
            modelContext.delete(selectedItem)
            self.selectedItem = nil
        }
    }
    
    private var filteredItems: [Item] {
        switch filter {
        case .all:
            items
        case .active:
            items.filter { !$0.isCompleted }
        case .completed:
            items.filter { $0.isCompleted }
        }
    }
}
