import Foundation
import SwiftUI

class User: Decodable, Identifiable {
    
    var appleId: UUID
    let uid: String
    let email: String
    let name: String
    let phone: String
    let photo: String
    
    init(uid: String,
         email: String,
         name: String,
         phone: String,
         photo: String) {
        self.appleId = UUID()
        self.uid = uid
        self.email = email
        self.name = name
        self.phone = phone
        self.photo = photo
    }
    
    init?(data: [String: Any]) {
        guard let appleId = data["appleId"] as? String,
            let uid = data["uid"] as? String,
              let email = data["email"] as? String,
              let name = data["displayName"] as? String,
              let phone = data["phoneNumber"] as? String,
              let photo = data["photoURL"] as? String  else {
            return nil
        }
        self.appleId = UUID(uuidString: appleId)!
        self.uid = uid
        self.email = email
        self.name = name
        self.phone = phone
        self.photo = photo
    }
    
    private enum CodingKeys: String, CodingKey {
        case appleId, email, uid
        case phone = "phoneNumber"
        case name = "displayName"
        case photo = "photoURL"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        appleId = UUID(uuidString: try container.decode(String.self, forKey: .appleId))!
        uid = try container.decode(String.self, forKey: .uid)
        email = try container.decode(String.self, forKey: .email)
        name = try container.decode(String.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        photo = try container.decode(String.self, forKey: .photo)
    }
    
}

extension User: Equatable {

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.appleId == rhs.appleId
    }

}

extension User: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(appleId)
    }
    
}
