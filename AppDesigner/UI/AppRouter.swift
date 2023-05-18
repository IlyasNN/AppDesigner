import Foundation
import SwiftUI

enum AppRouterScreen {
    case login
    case tab
}

class AppRouter: ObservableObject {
    
    @Published var screen: AppRouterScreen = .login
    
    lazy private var loginRouter: AuthorizationRouter = {
        return AuthorizationRouter()
    }()

    lazy private var tabRouter: TabRouter = {
        return TabRouter()
    }()
    
    init() {
        self.setBindings()
    }
    
    func setBindings() {
        
        guard RemoteConfigManager.shared.authorizationIsOn else {
            screen = .tab
            return
        }
        
        let status = AuthorizationManager.shared.authorizationStatus
        self.screen = status ? .tab : .login
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"),
                                               object: nil, queue: .main) { (_) in
            let status = UserDefaultsManager.shared.authorizationStatus
            self.screen = status ? .tab : .login
        }
    }
    
    @ViewBuilder func authorizationScreen() -> some View {
        AuthorizationRouterView(router: self.loginRouter)
    }
    
    @ViewBuilder func tabScreen() -> some View {
        TabRouterView(remoteConfigManager: RemoteConfigManager.shared,
                      router: self.tabRouter)
    }
    
}

struct AppRouterView: View {
    @StateObject var router: AppRouter
    
    var body: some View {
        switch self.router.screen {
        case .login:
            self.router.authorizationScreen()
        case .tab:
            self.router.tabScreen()
        }
    }
}
