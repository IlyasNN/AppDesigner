import Foundation

class HelpViewModel: ObservableObject {
    
    let firestoreManager: FirestoreManager
    
    @Published var helloMessage: String = ""
    
    init(firestoreManager: FirestoreManager) {
        self.firestoreManager = firestoreManager
        
        firestoreManager.loadHelloMessage { message in
            self.helloMessage = message ?? ""
        }
    }
    
    func sendMessage(message: String) {
        firestoreManager.sendHelpMessage(message: message) 
    }
}
