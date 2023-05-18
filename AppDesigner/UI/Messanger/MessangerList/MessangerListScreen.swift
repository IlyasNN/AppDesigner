import SwiftUI

struct MessangerListScreen: View {
    
    @StateObject var router: MessangerRouter
    @ObservedObject var viewModel: MessangerListViewModel
    
    @State private var selectedUser: User?
    
    var body: some View {
        
        VStack {
            HStack(spacing: 8) {
                TextField("Search...", text: $viewModel.searchText)
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
            }
            .padding(.top, 10)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.bottom, 5)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 10)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.bottom, 0)
            
            List {
                ForEach(
                    viewModel.filteredUsers,
                    id: \.self) { user in
                        ChatCell(text: user.name, avatarUrl: user.photo)
                            .onTapGesture {
                                selectedUser = user
                                router.navigateToChatScreen = true
                            }
                    }
            }
            .onAppear(perform: {
                UITableView.appearance().contentInset.top = -25
                let uuid = NSUUID().uuidString
                print(uuid)
            })
        }
        .background(Color(UIColor.secondarySystemBackground))
        .fullScreenCover(isPresented: $router.navigateToChatScreen) {
            if let selectedUser = selectedUser {
                router.chatScreen(user: selectedUser)
            }
        }
        
    }
}

struct MessagnerListScreen_Previews : PreviewProvider {
    static var previews: some View {
        let viewModel = MessangerListViewModel(authorizationManager: AuthorizationManager.shared,
                                               firestoreManager: FirestoreManager.shared)
        MessangerListScreen(router: MessangerRouter(),
                            viewModel: viewModel)
    }
}
