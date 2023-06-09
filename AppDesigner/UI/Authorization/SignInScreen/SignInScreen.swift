import SwiftUI

struct SignInScreen: View {
    
    @StateObject var router: AuthorizationRouter
    
    @State var user = ""
    @State var pass = ""
    @State var message = ""
    @State var alert = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Sign In")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .padding([.top, .bottom], 20)
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading) {
                        
                        Text("Username")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack {
                            
                            TextField("Enter Your Username", text: $user)
                            
                            if user != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading) {
                        
                        Text("Password")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color.init(.label).opacity(0.75))
                        
                        SecureField("Enter Your Password", text: $pass)
                        
                        Divider()
                    }
                    
                }.padding(.horizontal, 6)
                
                Button(action: {
                    
                    AuthorizationManager.shared.signInWithEmail(email: self.user,
                                                                password: self.pass) { (verified, status) in
                        
                        if !verified {
                            self.message = status
                            self.alert.toggle()
                        }
                    }
                    
                }) {
                    
                    Text("Sign In").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                    
                }.background(Color(RemoteConfigManager.shared.primaryColor))
                    .clipShape(Capsule())
                    .padding(.top, 45)
                
            }.padding()
                .alert(isPresented: $alert) {
                    Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
                }
            
            VStack {
                
                Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top, 30)
                
                HStack(spacing: 8) {
                    
                    Text("Don't Have An Account ?").foregroundColor(Color.gray.opacity(0.5))
                    
                    Button(action: {
                        
                        self.router.showSignUp.toggle()
                        
                    }) {
                        
                        Text("Sign Up")
                        
                    }.foregroundColor(.blue)
                    
                }.padding(.top, 25)
                
            }.sheet(isPresented: $router.showSignUp) {
                router.signUpScreen()
            }
        }
    }
}
