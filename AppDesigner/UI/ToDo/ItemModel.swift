//
//  Item.swift
//  ShoppingPalz
//
//  Created by Alfian Losari on 15/08/19.
//  Copyright © 2019 alfianlosari. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Item {
    var id: String
    var text: String
    var isDone: Bool
    var updatedBy: String
    var updatedAt: Date
    
    var diff: Int {
        return "\(id)\(text)\(isDone)\(updatedBy)\(updatedAt.timeIntervalSince1970)".hashValue
    }
}

extension Item {
    
    init(document: DocumentSnapshot) {
        self.id = document.documentID
        self.text = document.get("text") as? String ?? ""
        self.isDone = document.get("isDone") as? Bool ?? false
        self.updatedBy = document.get("updatedBy") as? String ?? ""
        self.updatedAt = document.get("updatedAt") as? Date ?? Date(timeIntervalSince1970: 0)
    }
    
    var toJSONSnapshot: [String: Any] {
        return [
            "text": self.text,
            "isDone": self.isDone,
            "updatedBy": self.updatedBy,
            "updatedAt": self.updatedAt
        ]
    }
}
