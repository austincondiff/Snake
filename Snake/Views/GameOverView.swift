//
//  GameOverView.swift
//  Snake
//
//  Created by Austin Condiff on 5/12/23.
//

import SwiftUI
import SwiftData

struct GameOverView: View {
    @EnvironmentObject var model: GameViewModel
    @Query(sort: \HighScore.score, order: .reverse) private var highScores: [HighScore]
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Game Over")
                .font(.largeTitle)
            if model.isNewHighScore {
                Text("New High Score!")
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
            VStack(spacing: 16) {
                VStack {
                    Text("Score")
                        .font(.subheadline)
                        .opacity(0.7)
                    Text("\(model.score)")
                        .font(.largeTitle)
                }
                if !model.isNewHighScore, let highScore = highScores.first?.score {
                    VStack {
                        Text("High Score")
                            .font(.subheadline)
                            .opacity(0.7)
                        Text("\(highScore)")
                            .font(.largeTitle)
                    }
                }
            }
            Spacer()
            VStack(spacing: 16) {
                Button("Play Again") {
                    model.startNewGame()
                }
                .buttonStyle(.primary)
                Button("Main Menu") {
                    model.stopGame()
                }
                .buttonStyle(.secondary)
                Button("Settings") {
                    model.showingSettings.toggle()
                }
                .buttonStyle(.secondary)
            }
        }
        .padding(20)
        .fontDesign(.monospaced)
        .fontWeight(.bold)
        .textCase(.uppercase)
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
