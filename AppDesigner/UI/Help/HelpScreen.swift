import SwiftUI

struct HelpScreen: View {
    
    @ObservedObject var viewModel: HelpViewModel
    
    @State var message: String = ""
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                VStack {
                    
                    Image("logo")
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(RemoteConfigManager.shared.primaryColor), lineWidth: 2)
                        )
                        .padding()
                    
                    Text(viewModel.helloMessage)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                    //                    .padding()
                    
                    Spacer()
                    
                    TextField("Message to hot line", text: $message)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                    
                    Button(action: {
                        viewModel.sendMessage(message: message)
                    }) {
                        Text("Send").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 64).padding()
                    }.background(Color(RemoteConfigManager.shared.primaryColor))
                        .clipShape(Capsule())

                }
                
                    .navigationTitle("Info")
                    .navigationBarColor(backgroundColor: UIColor(hex: RemoteConfigManager.shared.primaryColor),
                                        titleColor: .white)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                
            }
            .padding(16)
            .background(Color(UIColor.secondarySystemBackground))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HelpViewModel(firestoreManager: FirestoreManager.shared)
        HelpScreen(viewModel: viewModel)
    }
}
