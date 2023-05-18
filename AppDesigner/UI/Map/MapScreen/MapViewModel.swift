import Foundation
import CoreLocation
import SwiftUI

class MapViewModel: ObservableObject {
    
    let locationManager: LocationManager
    let firestoreManager: FirestoreManager
    let remoteConfigManager: RemoteConfigManager
    var mapPinModels: [MapPinModel] = []
    
    let addPinsIsOn: Bool
    
    @Published var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @Published var hasLocationAccess: Bool = true
    var selectedPin: MapPinModel?
    
    init(locationManager: LocationManager,
         firestoreManager: FirestoreManager,
         remoteConfigManager: RemoteConfigManager) {
        
        self.locationManager = locationManager
        self.firestoreManager = firestoreManager
        self.remoteConfigManager = remoteConfigManager
        
        self.addPinsIsOn = remoteConfigManager.addMapPinsIsOn
        
        locationManager.currentCoordinates.signal.addListener(skipCurrent: false,
                                                              skipRepeats: true) { [weak self] location in
            guard let location = locationManager.currentCoordinates.value else {
                self?.hasLocationAccess = false
                return
            }
            
            self?.currentLocation = location
        }
        
        firestoreManager.loadMapPins { mapPinModels in
            guard let mapPinModels = mapPinModels else {
                return
            }
            self.mapPinModels = mapPinModels
        }
        
    }
    
}
