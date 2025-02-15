import Foundation
import SwiftData

@Model
class HighScore {
    var score: Int
    var date: Date
    
    init(score: Int, date: Date = Date()) {
        self.score = score
        self.date = date
    }
} 