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

    @State private var newTodoTitle = ""

    var body: some View {
        NavigationSplitView {
            VStack {
                HStack {
                    TextField("New todo", text: $newTodoTitle)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        addItem()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()

                List {
                    ForEach(items) { item in
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
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Todos")
            .navigationSplitViewColumnWidth(min: 220, ideal: 260)
        } detail: {
            Text("Select a todo")
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
                modelContext.delete(items[index])
            }
        }
    }
}
