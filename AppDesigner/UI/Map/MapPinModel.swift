import Foundation

struct MapPinModel: Identifiable {
    
    var id: UUID
    var name: String
    var description: String
    var longitude: Double
    var latitude: Double
    var photoUrl: String?
    
    init?(data: [String: Any]) {
        guard let uid = data["uid"] as? String,
            let name = data["name"] as? String,
              let description = data["description"] as? String,
              let longitude = data["longitude"] as? Double,
              let latitude = data["latitude"] as? Double else {
            return nil
        }
        self.id = UUID(uuidString: uid)!
        self.name = name
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
        self.photoUrl = data["photoUrl"] as? String
    }
    
    init(name: String,
         description: String,
         longitude: Double,
         latitude: Double) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
    }
    
    var dictRepresentation: [String: Any] {
        ["uid": id.uuidString,
         "name": name,
         "description": description,
         "longitude": longitude,
         "latitude": latitude,
         "photoUrl": photoUrl ?? ""
        ]
    }
}
