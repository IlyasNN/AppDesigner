import Foundation
import FirebaseFirestore
import FirebaseStorage
import MapKit

class FirestoreManager {
    
    private init() {}
    static let shared = FirestoreManager()
    private let dataBase = Firestore.firestore()
    
    func registerUser(uid: String,
                      name: String,
                      email: String,
                      phoneNumber: String,
                      photoURL: String,
                      completion: @escaping (Bool, String) -> Void) {
        
        let values = ["appleId": UUID().uuidString,
                      "uid": uid,
                      "displayName": name,
                      "email": email,
                      "phoneNumber": phoneNumber,
                      "photoURL": photoURL]
        
        dataBase.collection("users").document(uid).setData(values) { error in
            
            guard let message = error?.localizedDescription else {
                completion(true, "SUCCESS")
                return
            }
            
            completion(false, message)
        }
    }
    
    func loadUser(uid: String,
                  completion: ((User?) -> Void)?) {
        let docRef = dataBase.collection("users")
            .document(uid)
        docRef.getDocument { document, error in
            guard error == nil,
                  let data = document?.data() else {
                return
            }
            let user = User(data: data)
            completion?(user)
        }
    }
    
    func updateUser(name: String?,
                    phone: String?) {
        
        let documentRef = dataBase
            .collection("users")
            .document(AuthorizationManager.shared.userUID)
        
        var data: [String: Any] = [:]
        if let name = name {
            data["displayName"] = name
        }
        if let phone = phone {
            data["phone"] = phone
        }
        
        documentRef.setData(data, merge: true)
    }
    
    func loadUsers(completion: (([User]?) -> Void)?) {
        let docRef = dataBase.collection("users")
        docRef.getDocuments { snapshot, error in
            guard error == nil,
                  let documents = snapshot?.documents else {
                return
            }
            var users: [User] = []
            for document in documents {
                if let user = User(data: document.data()) {
                    users.append(user)
                }
            }
            completion?(users)
        }
    }
    
    func loadMapPins(completion: (([MapPinModel]?) -> Void)?) {
        let docRef = dataBase.collection("map_pins")
        docRef.getDocuments { snapshot, error in
            guard error == nil,
                  let documents = snapshot?.documents else {
                return
            }
            var mapPins: [MapPinModel] = []
            for document in documents {
                if let user = MapPinModel(data: document.data()) {
                    mapPins.append(user)
                }
            }
            completion?(mapPins)
        }
    }
    
    func uploadMapPin(name: String,
                      description: String,
                      latitude: Double,
                      longitude: Double,
                      uiImage: UIImage?) {
        
        let uid = UUID().uuidString
        var values: [String: Any] = ["uid": uid,
                                     "name": name,
                                     "description": description,
                                     "longitude": longitude,
                                     "latitude": latitude,
                                     "photoUrl": ""]
        
        if let photo = uiImage {
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("map_pin_images").child("\(imageName).jpg")
            
            if let uploadData = photo.jpegData(compressionQuality: 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (_, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        guard let photoUrl = url else { return }
                        values["photoUrl"] = photoUrl.absoluteString
                        
                        self.dataBase.collection("map_pins").document(uid).setData(values)
                    })
                })
            }
            
        } else {
            dataBase.collection("map_pins").document(uid).setData(values)
        }
        
    }
    
    func sendHelpMessage(message: String) {
        let values: [String: Any] = ["userUID": AuthorizationManager.shared.userUID,
                                     "message": message]
        let uid = UUID().uuidString
        self.dataBase.collection("help_messages").document(uid).setData(values)
    }
    
    func loadHelloMessage(completion: ((String?) -> Void)?) {
        let docRef = dataBase.collection("help_messages")
            .document("hello_message")
        docRef.getDocument { document, error in
            guard error == nil,
                  let data = document?.data() else {
                return
            }
            let message = data["message"] as? String
            completion?(message)
        }
    }
    
}
