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
        VStack(spacing: 0) {
            ForEach(0..<Int(model.gridSize.y)) { row in
                HStack(spacing: 0) {
                    ForEach(0..<Int(model.gridSize.x)) { col in
                        var scale = model.isFood(Point(x: col, y: row)) ? 1.25 : 1
                        Rectangle()
                            .fill(model.getColorForPoint(x: col, y: row))
                            .cornerRadius(2.5)
                            .aspectRatio(1.0, contentMode: .fill)
//                                    .frame(width: gridSize.x, height: gridSize.y)
                            .padding(1)
                            .scaleEffect(scale)
                            .animation(.default, value: scale)
                    }
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { gesture in
                model.handleSwipeGesture(gesture)
            }
            .onEnded { gesture in
                model.lastGestureTranslation = CGSize(width: 0, height: 0)
            }
        )
    }
}
