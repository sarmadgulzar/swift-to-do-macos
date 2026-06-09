//
//  ContentView.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import SwiftData
import SwiftUI

enum TodoFilter: String, CaseIterable, Identifiable {
    case overdue = "Overdue"
    case today = "Today"
    case upcoming = "Upcoming"
    case someday = "Someday"
    case done = "Done"

    var id: Self { self }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Item.createdAt, order: .reverse)
    private var items: [Item]
    
    @State private var selectedItemID: UUID?
    @State private var newTodoTitle = ""
    @State private var filter: TodoFilter = .today
    @State private var searchText = ""

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

                List(selection: $selectedItemID) {
                    ForEach(filteredItems) { item in
                        HStack {
                            Button {
                                item.isCompleted.toggle()
                            } label: {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            }
                            .buttonStyle(.plain)

                            Text(item.title)
                                .strikethrough(item.isCompleted)
                                .foregroundStyle(titleColor(for: item))
                        }
                        .tag(item.id)
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
        .searchable(text: $searchText, prompt: "Search todos")
    }
    
    private var selectedItem: Item? {
        guard let selectedItemID else { return nil }

        return items.first { item in
            item.id == selectedItemID
        }
    }
    
    private func titleColor(for item: Item) -> Color {
        if item.isCompleted {
            return .secondary
        }

        if isOverdue(item) {
            return .red
        }

        return .primary
    }
    
    private func isOverdue(_ item: Item) -> Bool {
        guard let dueDate = item.dueDate else {
            return false
        }

        return !item.isCompleted &&
               !Calendar.current.isDateInToday(dueDate) &&
               dueDate < Date()
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
            selectedItemID = nil
        }
    }
    
    private var filteredItems: [Item] {
        let calendar = Calendar.current
        let today = Date()

        let filteredByStatus: [Item]

        switch filter {
        case .overdue:
            filteredByStatus = items.filter { item in
                guard let dueDate = item.dueDate else {
                    return false
                }

                return !item.isCompleted &&
                       !calendar.isDate(dueDate, inSameDayAs: today) &&
                       dueDate < today
            }

        case .today:
            filteredByStatus = items.filter { item in
                guard let dueDate = item.dueDate else {
                    return false
                }

                return !item.isCompleted &&
                       calendar.isDate(dueDate, inSameDayAs: today)
            }

        case .upcoming:
            filteredByStatus = items.filter { item in
                guard let dueDate = item.dueDate else {
                    return false
                }

                return !item.isCompleted &&
                       !calendar.isDate(dueDate, inSameDayAs: today) &&
                       dueDate > today
            }

        case .someday:
            filteredByStatus = items.filter { item in
                !item.isCompleted && item.dueDate == nil
            }

        case .done:
            filteredByStatus = items.filter { item in
                item.isCompleted
            }
        }

        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearch.isEmpty else {
            return filteredByStatus
        }

        return filteredByStatus.filter { item in
            item.title.localizedCaseInsensitiveContains(trimmedSearch)
            || item.notes.localizedCaseInsensitiveContains(trimmedSearch)
        }
    }
}
