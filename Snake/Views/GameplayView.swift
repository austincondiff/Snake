//
//  GameplayView.swift
//  Snake
//
//  Created by Austin Condiff on 5/12/23.
//

import SwiftUI

struct GameplayView: View {
    @EnvironmentObject var model: GameViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        model.paused.toggle()
                        if model.paused {
                            model.timer?.invalidate()
                        } else {
                            model.startTimer()
                        }
                    }) {
                        Image(systemName: model.paused ? "play.fill" : "pause.fill")
                            .foregroundColor(.primary)
                            .font(.title2)
                            .padding()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("Score")
                            .opacity(0.7)
                        Text("\(model.score)")
                    }
                    .font(.headline)
                    .fontDesign(.monospaced)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .padding()
                }
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            model.toolbarHeight = geometry.size.height
                            model.gridSize = model.screenSize(model.size)
                        }
                    }
                )
                ForEach(0..<model.gridSize.y, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<model.gridSize.x, id: \.self) { col in
                            let scale = model.isFood(Point(x: col, y: row)) ? 1.25 : 1
                            Rectangle()
                                .fill(model.getColorForPoint(x: col, y: row))
                                .cornerRadius(2.5)
                                .aspectRatio(1.0, contentMode: .fill)
                                .padding(1)
                                .scaleEffect(scale)
                                .animation(.default, value: scale)
                        }
                    }
                }
            }
            .blur(radius: model.paused || model.gameover ? 10 : 0)
            
            if model.paused {
                PauseView()
            }
            
            if model.gameover && !model.mainMenu {
                GameOverView()
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { gesture in
                    if !model.paused && !model.gameover {
                        model.handleSwipeGesture(gesture)
                    }
                }
                .onEnded { gesture in
                    model.lastGestureTranslation = CGSize(width: 0, height: 0)
                }
        )
    }
}
