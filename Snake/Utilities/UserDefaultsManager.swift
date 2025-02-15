import Foundation

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    // Keys
    private let wallEnabledKey = "wallEnabled"
    private let gridSizeKey = "gridSize"
    private let hapticsEnabledKey = "hapticsEnabled"
    
    // Wall Mode
    func getWallEnabled() -> Bool {
        defaults.bool(forKey: wallEnabledKey)
    }
    
    func setWallEnabled(_ value: Bool) {
        defaults.set(value, forKey: wallEnabledKey)
    }
    
    // Grid Size
    func getGridSize() -> Size {
        let rawValue = defaults.integer(forKey: gridSizeKey)
        return Size(rawValue: rawValue) ?? .medium
    }
    
    func setGridSize(_ value: Size) {
        defaults.set(value.rawValue, forKey: gridSizeKey)
    }
    
    // Haptics
    func getHapticsEnabled() -> Bool {
        defaults.bool(forKey: hapticsEnabledKey)
    }
    
    func setHapticsEnabled(_ value: Bool) {
        defaults.set(value, forKey: hapticsEnabledKey)
    }
    
    private init() {}
} 