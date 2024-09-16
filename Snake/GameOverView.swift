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
        VStack {
            Spacer()
            Text(model.mainMenu ? "Snake" : "Game Over")
                .foregroundColor(Color(.label))
                .font(.largeTitle)
                .fontDesign(.monospaced)
                .fontWeight(.bold)
                .textCase(.uppercase)
            Spacer()
            VStack(spacing: 20) {
                Button {
                    model.showingSettings.toggle()
                } label: {
                    Text("Settings")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(uiColor: .label))
                        .background(Color(uiColor: .label).opacity(0.15))
                        .fontDesign(.monospaced)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                }
                Button {
                    model.startNewGame()
                } label: {
                    Text(model.mainMenu ? "Start Game" : "New Game")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .background(Color(uiColor: .label))
                        .fontDesign(.monospaced)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                }
                .sheet(isPresented: $model.showingSettings) {
                    SettingsView(isPresented: $model.showingSettings, isWallEnabled: $model.isWallEnabled, size: $model.size)
                }
            }
            .padding(20)
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
