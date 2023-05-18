import Foundation

class ChatViewModel: ObservableObject {

    var user: User
    
    init(user: User) {
        self.user = user
    }
    
}
