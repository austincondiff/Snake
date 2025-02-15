//
//  SnakeApp.swift
//  Snake
//
//  Created by Austin Condiff on 3/28/23.
//

import SwiftUI
import SwiftData

@main
struct SnakeApp: App {
    let container: ModelContainer
    @StateObject private var gameViewModel: GameViewModel
    
    init() {
        do {
            container = try ModelContainer(for: HighScore.self)
            let context = container.mainContext
            _gameViewModel = StateObject(wrappedValue: GameViewModel(modelContext: context))
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameViewModel)
                .modelContainer(container)
        }
    }
}
