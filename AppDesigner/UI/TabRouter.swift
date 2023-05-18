import Foundation
import SwiftUI

class TabRouter: ObservableObject {
    
    let todoRouter = TodoRouter()
    let accountRouter = AccountRouter()
    let mapRouter = MapRouter()
    let messagnerRouter = MessangerRouter()
    
    @ViewBuilder func todo() -> some View {
//        let viewModel = HelpViewModel(firestoreManager: FirestoreManager.shared)
        TodoRouterView(router: self.todoRouter)
    }
    
    @ViewBuilder func home() -> some View {
        HomeScreen()
    }
    
    @ViewBuilder func help() -> some View {
        let viewModel = HelpViewModel(firestoreManager: FirestoreManager.shared)
        HelpScreen(viewModel: viewModel)
    }
    
    @ViewBuilder func map() -> some View {
        MapRouterView(router: self.mapRouter)
    }
    
    @ViewBuilder func messagner() -> some View {
        MessangerRouterView(router: self.messagnerRouter)
    }
    
    @ViewBuilder func account() -> some View {
        AccountRouterView(router: self.accountRouter)
    }
    
}

struct TabRouterView: View {
    
    var remoteConfigManager: RemoteConfigManager
    @StateObject var router: TabRouter
    
    var body: some View {
        TabView {
            
            if remoteConfigManager.todoFlowIsOn {
                self.router.todo()
                    .tabItem {
                        Label("ToDo", systemImage: "list.dash")
                    }
            }
            
            if remoteConfigManager.mapFlowIsOn {
                self.router.map()
                    .tabItem {
                        Label("Map", systemImage: "map.fill")
                    }
            }
            
            if remoteConfigManager.messagnerFlowIsOn {
            self.router.messagner()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
            }
            
            if remoteConfigManager.accountFlowIsOn {
            self.router.account()
                .tabItem {
                    Label("Account", systemImage: "person.fill")
                }
            }
            
            if remoteConfigManager.helpFlowIsOn {
            self.router.help()
                .tabItem {
                    Label("Help", systemImage: "questionmark.circle.fill")
                }
            }
            
        }
        .accentColor(Color(RemoteConfigManager.shared.primaryColor))
    }
}
