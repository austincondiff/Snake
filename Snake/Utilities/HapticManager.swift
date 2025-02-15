import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    var isEnabled: Bool = true
    
    private init() {
        // Initialize the feedback generator
        feedbackGenerator.prepare()
    }
    
    func playSuccess() {
        guard isEnabled else { return }
        feedbackGenerator.notificationOccurred(.success)
    }
    
    func playError() {
        guard isEnabled else { return }
        feedbackGenerator.notificationOccurred(.error)
    }
    
    func playWarning() {
        guard isEnabled else { return }
        feedbackGenerator.notificationOccurred(.warning)
    }
} 
