import Foundation
import SwiftUI

class AuthorizationRouter: ObservableObject {
    
    @Published var showSignUp: Bool = false
    
    @ViewBuilder func signInScreen() -> some View {
        // TODO: add ViewModel
        SignInScreen(router: self)
    }
    
    @ViewBuilder func signUpScreen() -> some View {
        // TODO: add ViewModel
        SignUpScreen(router: self)
    }
    
}

struct AuthorizationRouterView: View {
    @StateObject var router: AuthorizationRouter
    
    var body: some View {
        NavigationView {
            self.router.signInScreen()
                .navigationTitle("Authorization")
                .navigationBarColor(backgroundColor: UIColor(hex: RemoteConfigManager.shared.primaryColor),
                                    titleColor: .white)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
