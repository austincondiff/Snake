//
//  GameViewModel.swift
//  Snake
//
//  Created by Austin Condiff on 5/12/23.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var mainMenu: Bool = true
    @Published var timerInterval = 0.2
    @Published var gridSize:Point = Point(x: 0, y: 0)
    @Published var size:Size = Size.medium {
        didSet {
            gridSize = screenSize(size)
            print(gridSize)
        }
    }
    @Published var snake = Snake(body: [Point(x: 5, y: 5), Point(x: 4, y: 5), Point(x: 3, y: 5)], direction: .left)
    @Published var food = Point(x: 15, y: 15)
    @Published var gameover = true
    @Published var showingSettings = false
    @Published var isWallEnabled = false
    @Published var timer: Timer?
    @Published var lastGestureTranslation: CGSize = CGSize(width: 0, height: 0)
    @Published var paused: Bool = false

    func screenSize(_ size:Size) -> Point {
        let gridCount = size.rawValue
        let screenBounds = UIScreen.main.bounds
        let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
        let safeAreaScreenSize = CGSize(width: screenBounds.width - safeAreaInsets.left - safeAreaInsets.right,
                                        height: screenBounds.height - safeAreaInsets.top - safeAreaInsets.bottom)
        let gridItemSize = Int(safeAreaScreenSize.width)/gridCount
        let newGridSize = Point(x: gridCount, y: Int(safeAreaScreenSize.height)/gridItemSize)

        print(newGridSize)

        return newGridSize
    }

    func getColorForPoint(x: Int, y: Int) -> Color {
        let point = Point(x: x, y: y)
        if isFood(point) {
            return .accentColor
        } else if isBody(point) {
            return Color(.label)
        } else {
            return Color(uiColor: .quaternarySystemFill)
        }
    }

    func isFood(_ point: Point) -> Bool {
        return point == food
    }

    func isBody(_ point: Point) -> Bool {
        return snake.body.contains(point)
    }

    func handleSwipeGesture(_ gesture: DragGesture.Value) {
        let verticalDistance = gesture.translation.height - lastGestureTranslation.height
        let horizontalDistance = gesture.translation.width - lastGestureTranslation.width
        let threshold:CGFloat = 16

        if abs(verticalDistance) > abs(horizontalDistance) {
            if verticalDistance < -threshold && snake.direction != .down {
                snake.proposedDirection = .up

                lastGestureTranslation = gesture.translation
            } else if verticalDistance > threshold && snake.direction != .up {
                snake.proposedDirection = .down

                lastGestureTranslation = gesture.translation
            }
        } else {
            if horizontalDistance < -threshold && snake.direction != .right {
                snake.proposedDirection = .left

                lastGestureTranslation = gesture.translation
            } else if horizontalDistance > threshold && snake.direction != .left {
                snake.proposedDirection = .right

                lastGestureTranslation = gesture.translation

            }
        }

        print(gesture.translation.width, horizontalDistance, lastGestureTranslation.width)
    }

    func startNewGame() {
        self.snake = Snake(body: [Point(x: 5, y: 5), Point(x: 4, y: 5), Point(x: 3, y: 5)], direction: .left)
        self.food = Point(x: 15, y: 15)
        self.mainMenu = false
        self.gameover = false
        self.startTimer()
    }

    func moveSnake() {
        var newHead: Point
        var snake = self.snake

        if snake.proposedDirection != nil {
            snake.direction = snake.proposedDirection ?? .left
            snake.proposedDirection = nil
        }
        
        print(snake.direction)
        print(snake.head)

        switch snake.direction {
            case .up:
            newHead = Point(x: snake.head.x, y: !isWallEnabled && snake.head.y == 0 ? gridSize.y-1 : snake.head.y - 1)
            case .down:
            newHead = Point(x: snake.head.x, y: !isWallEnabled && snake.head.y == gridSize.y ? 0 : snake.head.y + 1)
            case .left:
            newHead = Point(x: !isWallEnabled && snake.head.x == 0 ? gridSize.x-1 : snake.head.x - 1, y: snake.head.y)
            case .right:
            newHead = Point(x: !isWallEnabled && snake.head.x == gridSize.x ? 0 : snake.head.x + 1, y: snake.head.y)
        }

       snake.body.append(newHead)

       if newHead == food {
           // generate new food
           var randomPoint: Point
           repeat {
               randomPoint = Point(x: Int.random(in: 0..<gridSize.x), y: Int.random(in: 0..<gridSize.y))
           } while snake.body.contains(randomPoint)
           self.food = randomPoint
           self.timerInterval = timerInterval * 0.9
           self.timer?.invalidate()
           self.startTimer()
       } else {
           snake.body.removeFirst()
       }

        // check for collision with walls or self
        if (self.isWallEnabled
               && (snake.head.x < 0
                    || snake.head.x >= gridSize.x
                    || snake.head.y < 0
                    || snake.head.y >= gridSize.y))
            || snake.body.dropLast().contains(snake.head) {
            print(snake.body, snake.head)
            self.gameover = true
            self.timer?.invalidate()
            self.timerInterval = 0.2
        }
    }

    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            if !self.gameover {
                self.moveSnake()
            } else {
                self.timer?.invalidate()
            }
        }
    }

    init() {}
}
