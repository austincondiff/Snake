//
//  ContentView.swift
//  Snake
//
//  Created by Austin Condiff on 3/28/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: GameViewModel

    var body: some View {
        ZStack {
            if model.gameover {
                if model.mainMenu {
                    MainMenuView()
                } else {
                    GameOverView()
                }
            } else {
                GameplayView()
                if model.paused {
                    PauseView()
                }

            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground).ignoresSafeArea())
//        .overlay {
//            Text(model.mainMenu ? "" : "\(model.snake.body.count - 3)")
//                .foregroundColor(Color(.label))
//                .font(.system(size: 150, weight: .heavy))
//                .opacity(0.15)
//                .fontDesign(.monospaced)
//                .fontWeight(.bold)
//        }
        .sheet(isPresented: $model.showingSettings) {
            SettingsView(
                isPresented: $model.showingSettings,
                isWallEnabled: $model.isWallEnabled,
                size: $model.size,
                isHapticsEnabled: $model.isHapticsEnabled
            )
        }
        .onAppear {
            model.startTimer()
            model.gridSize = model.screenSize(Size.medium)
        }
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

