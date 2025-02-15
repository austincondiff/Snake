//
//  MainMenuView.swift
//  Snake
//
//  Created by Austin Condiff on 2/6/25.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var model: GameViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Snake")
                .font(.largeTitle)
            Spacer()
            VStack(spacing: 16) {
                Button("Start Game") {
                    model.startNewGame()
                }
                .buttonStyle(.primary)
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

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
