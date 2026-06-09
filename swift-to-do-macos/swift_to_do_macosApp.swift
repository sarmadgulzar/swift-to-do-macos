//
//  swift_to_do_macosApp.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import SwiftUI
import SwiftData

@main
struct swift_to_do_macosApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .commands {
            CommandGroup(replacing: .newItem) {
                TodoCommandButton(title: "New Todo", shortcut: "n") { commands in
                    commands.createNewItem()
                }
            }

            CommandMenu("Todos") {
                TodoCommandButton(title: "Search", shortcut: "f") { commands in
                    commands.search()
                }

                Divider()

                TodoCommandButton(title: "Overdue", shortcut: "o") { commands in
                    commands.selectFilter(.overdue)
                }

                TodoCommandButton(title: "Today", shortcut: "t") { commands in
                    commands.selectFilter(.today)
                }

                TodoCommandButton(title: "Upcoming", shortcut: "u") { commands in
                    commands.selectFilter(.upcoming)
                }

                TodoCommandButton(title: "Someday", shortcut: "s") { commands in
                    commands.selectFilter(.someday)
                }

                TodoCommandButton(title: "Done", shortcut: "d") { commands in
                    commands.selectFilter(.done)
                }
            }
        }
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
