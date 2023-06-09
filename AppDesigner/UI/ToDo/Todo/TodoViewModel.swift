import SwiftUI
import Combine
import FirebaseFirestore

// swiftlint:disable: identifier_name

class ShoppingListFirestoreRepository {
    
    private var listener: ListenerRegistration?
    private var db = Firestore.firestore().collection("todo_notes")
    
    func startListener(result: @escaping (Result<[Item], Error>) -> Void) {
        stopListener()
        
        listener = db
            .order(by: "isDone", descending: false)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    result(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    result(.failure(NSError(domain: "",
                                            code: 0,
                                            userInfo: [NSLocalizedDescriptionKey: "Snapshot is empty"])))
                    return
                }
                
                let items = documents.map { Item(document: $0) }
                result(.success(items))
        }
    }
    
    func addItem(_ item: Item) {
        db.document(item.id).setData(item.toJSONSnapshot)
    }
    
    func updateItem(_ item: Item) {
        db.document(item.id).updateData(item.toJSONSnapshot)
    }
    
    func removeItem(_ item: Item) {
        db.document(item.id).delete()
    }
    
    func stopListener() {
        listener?.remove()
        listener = nil
    }
    
    deinit {
        stopListener()
    }
    
}

class ShoppingList: ObservableObject {
    
    @Published var items: (pending: [Item], purchased: [Item]) = ([], [])
    @Published var error: Error?
    var repository = ShoppingListFirestoreRepository()
    
    func startListener() {
        self.error = nil
        
        repository.startListener {[weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let items):
                self.items = (items.filter { !$0.isDone }, items.filter { $0.isDone })
                
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func addItem(_ item: Item) {
        repository.addItem(item)
    }
    
    func updateItem(_ item: Item) {
        var _item = item
        _item.isDone.toggle()
        repository.updateItem(_item)
    }
    
    func removeItem(_ item: Item) {
        repository.removeItem(item)
    }
    
    func stopListener() {
        repository.stopListener()
    }
}
