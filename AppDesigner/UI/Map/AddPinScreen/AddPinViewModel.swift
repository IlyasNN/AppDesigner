import Foundation
import UIKit

class AddPinViewModel: ObservableObject {
    
    let firestoreManager: FirestoreManager
    
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var image: UIImage?
    
    private var latitude: Double
    private var longitude: Double
    
    init(firestoreManager: FirestoreManager,
         latitude: Double,
         longitude: Double) {
        self.firestoreManager = firestoreManager
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func saveNewPinToFirebase() {
        firestoreManager.uploadMapPin(name: name,
                                      description: description,
                                      latitude: latitude,
                                      longitude: longitude,
                                      uiImage: image)
    }
    
}
