//
//  GameOverView.swift
//  Snake
//
//  Created by Austin Condiff on 5/12/23.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var model: GameViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Game Over")
                .foregroundColor(Color(.label))
                .font(.largeTitle)
                .fontDesign(.monospaced)
                .fontWeight(.bold)
                .textCase(.uppercase)
            Text("Score: \(model.score)")
                .font(.title)
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
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
