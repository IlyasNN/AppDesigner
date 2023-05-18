import Foundation

class MessangerListViewModel: ObservableObject {
    
    let authorizationManager: AuthorizationManager
    let firestoreManager: FirestoreManager
    
    @Published var searchText = "" {
        didSet {
            updateFilteredUsers()
        }
    }
    
    @Published var users: [User] = []
    @Published var filteredUsers: [User] = []
    var selectedUser: User?
    
    init(authorizationManager: AuthorizationManager,
         firestoreManager: FirestoreManager) {
        
        self.firestoreManager = firestoreManager
        self.authorizationManager = authorizationManager
        
        firestoreManager.loadUsers { users in
            guard let users = users else {
                return
            }
            self.users = users.filter({
                $0.uid != authorizationManager.userUID
            })
            self.updateFilteredUsers()
        }
    }
    
    func updateFilteredUsers() {
        guard !searchText.isEmpty else {
            filteredUsers = users
            return
        }
        filteredUsers = users.filter {
            $0.name.contains(searchText)
        }
    }
    
}
