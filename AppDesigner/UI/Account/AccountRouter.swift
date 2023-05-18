import Foundation
import SwiftUI

class AccountRouter: ObservableObject {
    
    @Published var navigateToEditAccountScreen = false
    
    @ViewBuilder func accountScreen() -> some View {
        let viewModel = AccountViewModel(authorizationManager: AuthorizationManager.shared,
                                         firestoreManager: FirestoreManager.shared)
        AccountScreen(router: self,
                      viewModel: viewModel)
    }
    
    @ViewBuilder func editAccountScreen(user: User) -> some View {
        let viewModel = EditAccountViewModel(firestoreManager: FirestoreManager.shared,
                                             user: user)
        EditAccountScreen(router: self,
                          viewModel: viewModel)
    }
    
}

struct AccountRouterView: View {
    
    @StateObject var router: AccountRouter
    
    var body: some View {
        NavigationView {
            self.router.accountScreen()
            
                .navigationBarColor(backgroundColor: UIColor(hex: RemoteConfigManager.shared.primaryColor),
                                    titleColor: .white)
                .navigationTitle("Account")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
