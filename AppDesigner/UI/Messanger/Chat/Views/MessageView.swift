import SwiftUI

struct MessageView: View {
    let message: Message
    let shouldDrawTail: Bool
    
    private var activeBackgroundColor: Color {
        message.sender == .own ? Color(UIColor(hex: RemoteConfigManager.shared.primaryColor)!)
        : Color("MessageBackgroundOtherUser")
    }
    private var activeForegroundColor: Color {
        message.sender == .own ? Color("MessageForegroundCurrentUser") : Color("MessageForegroundOtherUser")
    }
    
    var body: some View {
        HStack {
            if message.sender == .own {
                Spacer()
            }
            
            VStack(alignment: message.sender == .own ? .trailing : .leading, spacing: 0) {
                Text(message.content)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(activeBackgroundColor)
                    .foregroundColor(activeForegroundColor)
                    .cornerRadius(16)
                    .offset(x: message.sender == .own ? -4 : 4, y: 0)
                
                if shouldDrawTail {
                    MessageTailView(sender: message.sender) { self.activeBackgroundColor }
                        .frame(width: 20, height: 16, alignment: .leading)
                        .offset(x: 0, y: -8)
                }
            }
            
            if message.sender != .own {
                Spacer()
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: Message.mock, shouldDrawTail: true)
    }
}
