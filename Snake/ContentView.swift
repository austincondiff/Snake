//
//  ContentView.swift
//  Snake
//
//  Created by Austin Condiff on 3/28/23.
//

import SwiftUI

struct Point: Equatable {
    var x: Int
    var y: Int
}

struct Snake {
    var body: [Point]
    var direction: Direction
    var proposedDirection: Direction?

    enum Direction {
        case up, down, left, right
    }

    var head: Point {
        return body.last!
    }
}

enum Size: Int {
    case small = 24
    case medium = 32
    case large = 48
}

struct ContentView: View {
    @EnvironmentObject var model: GameViewModel

    var body: some View {
        ZStack {
            if model.gameover {
                GameOverView()
            } else {
                if model.paused {
                    PauseView()
                }
                GameplayView()

            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground).ignoresSafeArea())
        .overlay {
            Text(model.mainMenu ? "" : "\(model.snake.body.count - 3)")
                .foregroundColor(Color(.label))
                .font(.system(size: 150, weight: .heavy))
                .opacity(0.15)
                .fontDesign(.monospaced)
                .fontWeight(.bold)
        }
        .onAppear {
            model.startTimer()
            model.gridSize = model.screenSize(Size.medium)
        }
    }

    
}

struct SettingsView: View {
    @Binding var isPresented: Bool
    @Binding var isWallEnabled: Bool
    @Binding var size: Size

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Game Settings")) {
                    Toggle("Enable Walls", isOn: $isWallEnabled)
                    Picker("Size", selection: $size) {
                        Text("Small").tag(Size.small)
                        Text("Medium").tag(Size.medium)
                        Text("Large").tag(Size.large)
                    }
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

