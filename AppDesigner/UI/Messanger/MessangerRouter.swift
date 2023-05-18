import Foundation
import SwiftUI

class MessangerRouter: ObservableObject {
    
    @Published var navigateToChatScreen: Bool = false
    
    @ViewBuilder func messangerListScreen() -> some View {
        let viewModel = MessangerListViewModel(authorizationManager: AuthorizationManager.shared,
                                               firestoreManager: FirestoreManager.shared)
        MessangerListScreen(router: self, viewModel: viewModel)
    }
    
    @ViewBuilder func chatScreen(user: User) -> some View {
        let viewModel = ChatViewModel(user: user)
        ChatScreen(router: self, viewModel: viewModel)
    }
    
}

struct MessangerRouterView: View {
    
    @StateObject var router: MessangerRouter
    
    var body: some View {
        NavigationView {
            self.router.messangerListScreen()
  
                .navigationBarColor(backgroundColor: UIColor(hex: RemoteConfigManager.shared.primaryColor),
                                    titleColor: .white)
                .navigationTitle("Chats")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
