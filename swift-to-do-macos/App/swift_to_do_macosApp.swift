//
//  swift_to_do_macosApp.swift
//  swift-to-do-macos
//
//  Created by Sarmad Gulzar on 09/06/2026.
//

import SwiftData
import SwiftUI

@main
struct swift_to_do_macosApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
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

                TodoCommandButton(title: "Overdue", shortcut: "o") { $0.selectFilter(.overdue) }
                TodoCommandButton(title: "Today", shortcut: "t") { $0.selectFilter(.today) }
                TodoCommandButton(title: "Upcoming", shortcut: "u") { $0.selectFilter(.upcoming) }
                TodoCommandButton(title: "Someday", shortcut: "s") { $0.selectFilter(.someday) }
                TodoCommandButton(title: "Done", shortcut: "d") { $0.selectFilter(.done) }
            }
        }
    }
}
