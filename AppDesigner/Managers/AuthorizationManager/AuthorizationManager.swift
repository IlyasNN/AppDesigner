import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthorizationManager {
    
    static let shared = AuthorizationManager()
    
    private(set) var authorizationStatus: Bool {
        get {
            UserDefaultsManager.shared.authorizationStatus
        }
        set {
            UserDefaultsManager.shared.authorizationStatus = newValue
        }
    }
    
    private(set) var userUID: String {
        get {
            UserDefaultsManager.shared.userUID
        }
        set {
            UserDefaultsManager.shared.userUID = newValue
        }
    }
    
    var user: Emitter<User?> = Emitter(nil)
    
    func signInWithEmail(email: String,
                         password : String,
                         completion: @escaping (Bool, String) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
            
            if error != nil {
                completion(false, (error?.localizedDescription)!)
                return
            }
            
            guard let uid = res?.user.uid else { return }
            
            FirestoreManager.shared.loadUser(uid: uid) { user in
                guard let user = user else {
                    return
                }
                self.user.value = user
            }
            self.userUID = uid
            self.authorizationStatus = true
            completion(true, (res?.user.email)!)
        }
        
    }
    
    func signUpWithEmail(email: String,
                         name: String,
                         phone: String,
                         photo: UIImage,
                         password: String,
                         completion: @escaping (Bool, String) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            
            if error != nil {
                completion(false, (error?.localizedDescription)!)
                return
            }
            
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            guard let uid = res?.user.uid else { return }
            
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
                        
                        FirestoreManager.shared.registerUser(uid: uid,
                                                             name: name,
                                                             email: email,
                                                             phoneNumber: phone,
                                                             photoURL: photoUrl.absoluteString) { verified, message in
                            if verified {
                                FirestoreManager.shared.loadUser(uid: uid) { user in
                                    guard let user = user else {
                                        return
                                    }
                                    self.user.value = user
                                }
                                UserDefaultsManager.shared.userUID = uid
                                UserDefaultsManager.shared.authorizationStatus = true
                            }
                            completion(verified, message)
                        }
                        
                    })
                })
            }
            
        }
    }
    
    func signOut() {
        UserDefaultsManager.shared.userUID = ""
        UserDefaultsManager.shared.authorizationStatus = false
    }
    
}
