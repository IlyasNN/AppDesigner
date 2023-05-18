import Foundation

class EditAccountViewModel: ObservableObject {
    
    let firestoreManager: FirestoreManager
    
    @Published var user: User
    
    init(firestoreManager: FirestoreManager,
         user: User) {
        self.firestoreManager = firestoreManager
        self.user = user
    }
    
    func updateData(name: String, phone: String) {
        firestoreManager.updateUser(name: name,
                                    phone: phone)
    }
    
}
