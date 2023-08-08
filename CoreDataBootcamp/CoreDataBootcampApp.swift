//
//  CoreDataBootcampApp.swift
//  CoreDataBootcamp
//
//  Created by Kirill Streltsov on 08.08.23.
//

import SwiftUI

@main
struct CoreDataBootcampApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
