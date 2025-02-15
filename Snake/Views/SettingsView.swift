//
//  SettingsView.swift
//  Snake
//
//  Created by Austin Condiff on 2/6/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Binding var isPresented: Bool
    @Binding var isWallEnabled: Bool
    @Binding var size: Size
    @Binding var isHapticsEnabled: Bool
    @Environment(\.modelContext) private var modelContext
    @State private var showingResetConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Wall Mode", isOn: $isWallEnabled)
                    Toggle("Haptic Feedback", isOn: $isHapticsEnabled)
                }
                
                Section {
                    Picker("Grid Size", selection: $size) {
                        Text("Small").tag(Size.small)
                        Text("Medium").tag(Size.medium)
                        Text("Large").tag(Size.large)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingResetConfirmation = true
                    } label: {
                        Text("Reset High Scores")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
            .alert("Reset High Scores", isPresented: $showingResetConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetHighScores()
                }
            } message: {
                Text("Are you sure you want to reset all high scores? This cannot be undone.")
            }
        }
    }
    
    private func resetHighScores() {
        do {
            try modelContext.delete(model: HighScore.self)
        } catch {
            print("Failed to reset high scores: \(error)")
        }
    }
}
