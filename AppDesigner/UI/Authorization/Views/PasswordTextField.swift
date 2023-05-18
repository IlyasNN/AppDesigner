import SwiftUI

struct PasswordTextfield: View {
    
    @Binding var password: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Password")
                .font(.headline)
                .fontWeight(.light)
                .foregroundColor(Color.init(.label).opacity(0.75))
            
            SecureField("Enter Your Password", text: $password)
            
            Divider()
        }
    }
}
