import Foundation

enum UserDefaultsKeys: String {
    case authorizationStatus
    case userUID
}

class UserDefaultsManager {

    private init() {}
    static let shared = UserDefaultsManager()
    let userDefaults = UserDefaults.standard
    
    var authorizationStatus: Bool {
        get {
            userDefaults.bool(forKey: UserDefaultsKeys.authorizationStatus.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.authorizationStatus.rawValue)
            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
        }
    }
    
    var userUID: String {
        get {
            userDefaults.string(forKey: UserDefaultsKeys.userUID.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.userUID.rawValue)
        }
    }
    
}
