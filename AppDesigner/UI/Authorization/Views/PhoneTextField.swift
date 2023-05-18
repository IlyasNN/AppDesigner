import SwiftUI
import iPhoneNumberField

struct PhoneTextfield: View {
    
    @Binding var phone: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Phone")
                .font(.headline)
                .fontWeight(.light)
                .foregroundColor(Color.init(.label).opacity(0.75))
            
            iPhoneNumberField("Enter Phone", text: $phone)
                .flagHidden(false)
                .flagSelectable(true)
                .foregroundColor(Color.init(.label).opacity(0.75))
            
            Divider()
        }
    }
    
}
