import SwiftUI
import iPhoneNumberField

struct SignUpScreen: View {
    
    @StateObject var router: AuthorizationRouter
    
    @State var email = ""
    @State var username = ""
    @State var phone = ""
    @State var password = ""
    @State var message = ""
    @State var alert = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Text("Sign Up")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .padding([.top, .bottom], 20)
                
                VStack(alignment: .leading) {
                    
                    DefaultTextfield(title: "Email", value: $email)
                    DefaultTextfield(title: "Username", value: $username)
                    PhoneTextfield(phone: $phone)
                    PasswordTextfield(password: $password)
                    
                }.padding(.horizontal, 6)
                
                Button(action: {
                    
                    AuthorizationManager.shared.signUpWithEmail(email: email,
                                                                name:  username,
                                                                phone: phone,
                                                                photo: UIImage(named: "avatar")!,
                                                                password: password) { (verified, status) in
                        if !verified {
                            self.message = status
                            self.alert.toggle()
                        } else {
                            self.router.showSignUp.toggle()
                        }
                    }
                    
                }) {
                    Text("Sign Up").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                }.background(Color(RemoteConfigManager.shared.primaryColor))
                    .clipShape(Capsule())
                    .padding(.top, 45)
                
            }.padding()
                .alert(isPresented: $alert) {
                    
                    Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
                }
            
                .navigationBarColor(backgroundColor: .clear, titleColor: .clear)
                .navigationBarItems(leading: Button {
                    router.showSignUp = false
                } label: {
                    Text("Cancel")
                        .foregroundColor(.black)
                })
            
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen(router: AuthorizationRouter())
    }
}
