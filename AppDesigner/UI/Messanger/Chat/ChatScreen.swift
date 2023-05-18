import SwiftUI

struct ChatScreen: View {
    
    @StateObject var router: MessangerRouter
    @ObservedObject var viewModel: ChatViewModel
    
    @State var messages: [Message] = {
        let decoder = JSONDecoder()
        let data = allMessagesString.data(using: .utf8)!
        // swiftlint:disable:next force_try
        return try! decoder.decode([Message].self, from: data)
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MessageListView(messages: messages)
                
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 1)
                        .shadow(radius: 4)
                    
                    MessageInputView { enteredText in
                        let id = (self.messages.map { $0.id }.max() ?? 0) + 1
                        let message = Message(id: id, sender: .own, content: enteredText)
                        self.messages.append(message)
                    }
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 44)
                }
            }
            .padding(.top, 10)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle(viewModel.user.name, displayMode: .automatic)
            .navigationBarItems(leading: Button {
                router.navigateToChatScreen = false
            } label: {
                Text("back")
                    .foregroundColor(.white)
            })
        }
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen(router: MessangerRouter(),
                   viewModel: ChatViewModel(user: User(uid: "000",
                                                       email: "Email",
                                                       name: "Name Name",
                                                       phone: "12345678",
                                                       photo: "some url")))
    }
}

let allMessagesString = """
[
    {
        "id": 0,
        "content": "Hi there John!",
        "sender": "me"
    },
    {
        "id": 1,
        "content": "Hello.",
        "sender": "John"
    },
    {
        "id": 2,
        "content": "What's for dinner tomorrow? I've been thinking about making some triple layered apple pie with the Golden Smiths that Jonathan has given us.",
        "sender": "me"
    },
    {
        "id": 3,
        "content": "How about some fried apples?",
        "sender": "John"
    }
]
"""
