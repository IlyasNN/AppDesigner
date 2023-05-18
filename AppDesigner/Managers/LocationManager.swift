import Foundation
import CoreLocation
import MapKit

extension CLLocationCoordinate2D: Equatable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
}

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    private override init() {
        clLocationManager = CLLocationManager()
        super.init()
        clLocationManager.delegate = self
        clLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if Self.locationServicesEnabled {
            clLocationManager.startUpdatingLocation()
        }
    }
    
    static var locationServicesEnabled: Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    private let clLocationManager: CLLocationManager
    
    var currentCoordinates: Emitter<CLLocationCoordinate2D?> = .init(nil)
    
    func requestAlwaysAndWhenInUseAccess() {
        clLocationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatinglocation() {
        clLocationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentCoordinates.value = locations.first?.coordinate
    }
    
}
