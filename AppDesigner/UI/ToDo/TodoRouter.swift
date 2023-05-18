import Foundation
import SwiftUI

class TodoRouter: ObservableObject {
    
    @ViewBuilder func todoScreen() -> some View {
        TodoScreen().environmentObject(ShoppingList())
    }
    
}

struct TodoRouterView: View {
    
    var router: TodoRouter
    
    var body: some View {
        NavigationView {
            self.router.todoScreen()
                .navigationTitle("ToDo")
                .navigationBarColor(backgroundColor: UIColor(hex: RemoteConfigManager.shared.primaryColor),
                                    titleColor: .white)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
