//
//  Snake.swift
//  Snake
//
//  Created by Austin Condiff on 2/6/25.
//

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
