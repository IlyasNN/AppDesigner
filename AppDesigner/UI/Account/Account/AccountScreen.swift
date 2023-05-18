import SwiftUI
import FirebaseFirestore

struct AccountScreen: View {
    
    @StateObject var router: AccountRouter
    @ObservedObject var viewModel: AccountViewModel
    
    var body: some View {
        
        List {
            
            Section {
                HStack {
                    Spacer()
                    if let user = viewModel.user {
                        AsyncImage(url: URL(string: user.photo)!,
                                   placeholder: {
                            Image("avatar")
                                .resizable()
                                .frame(width: 200, height: 200)
                        })
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.black, lineWidth: 2))
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        
                        Spacer()
                    }
                }
                .padding(.top, 32)
                .listRowBackground(Color(UIColor.secondarySystemBackground))
            }
            
            Section(header: Text("Name")) {
                Text(viewModel.user?.name ?? "")
            }
            
            Section(header: Text("Email")) {
                Text(viewModel.user?.email ?? "")
            }
            
            Section(header: Text("Phone")) {
                Text(viewModel.user?.phone ?? "")
            }
            
        }
        
        .sheet(isPresented: $router.navigateToEditAccountScreen) {
            if let user = viewModel.user {
                router.editAccountScreen(user: user)
            }
        }
        
        .navigationBarItems(leading: Button {
            router.navigateToEditAccountScreen = true
        } label: {
            Text("Edit")
                .foregroundColor(.white)
        }, trailing: Button {
            AuthorizationManager.shared.signOut()
        } label: {
            Text("Log out")
                .foregroundColor(.white)
        })
        .navigationTitle(Text("Account"))
        
        .onAppear {
            viewModel.loadUser()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AccountViewModel(authorizationManager: AuthorizationManager.shared,
                                         firestoreManager: FirestoreManager.shared)
        AccountScreen(router: AccountRouter(), viewModel: viewModel)
    }
}
