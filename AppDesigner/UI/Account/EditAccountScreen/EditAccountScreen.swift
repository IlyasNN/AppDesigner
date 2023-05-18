import SwiftUI

struct EditAccountScreen: View {
    
    @StateObject var router: AccountRouter
    @ObservedObject var viewModel: EditAccountViewModel
    
    @State var email: String = ""
    @State var name: String = ""
    @State var phone: String = ""
    
    var body : some View {
        NavigationView {
            VStack {
                
                VStack(alignment: .leading) {
                    
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
                    
                    DefaultTextfield(title: "Username", value: $name)
                    DefaultTextfield(title: "Email", value: $email)
                    PhoneTextfield(phone: $phone)
                    
                }.padding(.horizontal, 6)
                
                Spacer()
            }
            .padding()
            
            .navigationBarItems(leading: Button {
                router.navigateToEditAccountScreen = false
            } label: {
                Text("Cancel")
                    .foregroundColor(.white)
            }, trailing: Button {
                viewModel.updateData(name: name,
                                     phone: phone)
                router.navigateToEditAccountScreen = false
            } label: {
                Text("Done")
                    .foregroundColor(.white)
            }
                                
            )
            .navigationBarTitle("Edit account", displayMode: .inline)
            .navigationBarColor(backgroundColor: UIColor(hex: RemoteConfigManager.shared.primaryColor),
                                titleColor: .white)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        .onAppear {
            name = viewModel.user.name
            phone = viewModel.user.phone
            email = viewModel.user.email
        }
    }
}

struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = EditAccountViewModel(firestoreManager: FirestoreManager.shared,
                                             user: User(uid: "uid",
                                                        email: "email",
                                                        name: "name",
                                                        phone: "phone",
                                                        photo: ""))
        EditAccountScreen(router: AccountRouter(),
                          viewModel: viewModel)
    }
}
