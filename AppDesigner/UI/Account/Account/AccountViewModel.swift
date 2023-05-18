import Foundation

class AccountViewModel: ObservableObject {
    
    let authorizationManager: AuthorizationManager
    let firestoreManager: FirestoreManager
    
    @Published var user: User?
    
    init(authorizationManager: AuthorizationManager,
         firestoreManager: FirestoreManager) {
        
        self.authorizationManager = authorizationManager
        self.firestoreManager = firestoreManager
        
        loadUser()
    }
    
    func loadUser() {
        if authorizationManager.authorizationStatus {
            firestoreManager.loadUser(uid: authorizationManager.userUID) { user in
                guard let user = user else {
                    return
                }
                self.user = user
            }
        }
    }
}
