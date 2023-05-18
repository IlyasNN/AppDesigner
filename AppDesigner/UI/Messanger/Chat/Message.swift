import Foundation

struct Message: Hashable, Identifiable, Decodable {
    enum Sender: Hashable {
        case own
        case other(named: String)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case sender
        case content
    }
    
    let id: Int
    let sender: Sender
    let content: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        
        let senderString = try container.decode(String.self, forKey: .sender)
        if senderString == "me" {
            sender = .own
        } else {
            sender = .other(named: senderString)
        }
    }
    
    init(id: Int, sender: Sender, content: String) {
        self.id = id
        self.sender = sender
        self.content = content
    }
}

extension Message {
    static let mock: Self = .init(id: -1, sender: .own, content: "Hello World!")
}
