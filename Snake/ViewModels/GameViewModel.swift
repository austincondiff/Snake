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
    @Published var toolbarHeight: CGFloat = 0
    @Published var score: Int = 0

    func screenSize(_ size:Size) -> Point {
        let gridCount = size.rawValue
        let screenBounds = UIScreen.main.bounds
        
        // Get the window scene's safe area insets
        let safeAreaInsets: UIEdgeInsets
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            safeAreaInsets = window.safeAreaInsets
        } else {
            safeAreaInsets = .zero
        }
        
        let safeAreaScreenSize = CGSize(
            width: screenBounds.width - safeAreaInsets.left - safeAreaInsets.right,
            height: screenBounds.height - safeAreaInsets.top - safeAreaInsets.bottom - toolbarHeight
        )
        
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
        self.score = 0
        self.startTimer()
    }
    
    func stopGame() {
        self.mainMenu = true
        self.gameover = true
        self.paused = false
    }

    func moveSnake() {
        var newHead: Point
        
        if self.snake.proposedDirection != nil {
            self.snake.direction = self.snake.proposedDirection ?? .left
            self.snake.proposedDirection = nil
        }
        
        print(self.snake.direction)
        print(self.snake.head)

        switch self.snake.direction {
            case .up:
                newHead = Point(x: self.snake.head.x, y: !isWallEnabled && self.snake.head.y == 0 ? gridSize.y-1 : self.snake.head.y - 1)
            case .down:
                newHead = Point(x: self.snake.head.x, y: !isWallEnabled && self.snake.head.y == gridSize.y-1 ? 0 : self.snake.head.y + 1)
            case .left:
                newHead = Point(x: !isWallEnabled && self.snake.head.x == 0 ? gridSize.x-1 : self.snake.head.x - 1, y: self.snake.head.y)
            case .right:
                newHead = Point(x: !isWallEnabled && self.snake.head.x == gridSize.x-1 ? 0 : self.snake.head.x + 1, y: self.snake.head.y)
        }

        self.snake.body.append(newHead)

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
            self.score += 10
        } else {
            self.snake.body.removeFirst()
        }

        // check for collision with walls or self
        if (self.isWallEnabled
               && (self.snake.head.x < 0
                    || self.snake.head.x >= gridSize.x
                    || self.snake.head.y < 0
                    || self.snake.head.y >= gridSize.y))
            || self.snake.body.dropLast().contains(self.snake.head) {
            print(self.snake.body, self.snake.head)
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
