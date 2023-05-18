import Foundation
import FirebaseRemoteConfig

class RemoteConfigManager {
    
    static let shared = RemoteConfigManager()
    private init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 10
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
        remoteConfig.fetchAndActivate()
    }
    
    let remoteConfig: RemoteConfig
    
    var authorizationIsOn: Bool {
        remoteConfig["authorization"].boolValue
    }
    
    var mapFlowIsOn: Bool {
        remoteConfig["mapFlow"].boolValue
    }
    
    var addMapPinsIsOn: Bool {
        remoteConfig["addMapPins"].boolValue
    }
    
    var helpFlowIsOn: Bool {
        remoteConfig["helpFlow"].boolValue
    }
    
    var todoFlowIsOn: Bool {
        remoteConfig["todoFlow"].boolValue
    }
    
    var messagnerFlowIsOn: Bool {
        remoteConfig["todoFlow"].boolValue
    }
    
    var accountFlowIsOn: Bool {
        remoteConfig["accountFlow"].boolValue
    }
    
    var primaryColor: String {
        remoteConfig["primaryColor"].stringValue!
    }
    
    func configure() {}
    
}
