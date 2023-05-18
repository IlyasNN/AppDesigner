import SwiftUI

struct DefaultTextfield: View {
    
    let title: String
    @Binding var value: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(title)
                .font(.headline)
                .fontWeight(.light)
                .foregroundColor(Color.init(.label).opacity(0.75))
            
            HStack {
                
                TextField("Enter Your \(title)", text: $value)
                
                if value != ""{
                    Image("check")
                        .foregroundColor(Color.init(.label))
                }
                
            }
            
            Divider()
            
        }.padding(.bottom, 15)
        
    }
    
}
