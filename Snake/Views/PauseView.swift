//
//  PauseView.swift
//  Snake
//
//  Created by Austin Condiff on 5/12/23.
//

import SwiftUI

struct PauseView: View {
    @EnvironmentObject var model: GameViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Paused")
                .foregroundColor(Color(.label))
                .font(.largeTitle)
            Spacer()
            VStack(spacing: 16) {
                Button("Resume") {
                    model.paused = false
                    model.startTimer()
                }
                .buttonStyle(.primary)
                Button("Main Menu") {
                    model.stopGame()
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

struct PauseView_Previews: PreviewProvider {
    static var previews: some View {
        PauseView()
    }
}
