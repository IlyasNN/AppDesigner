import SwiftUI

struct TodoScreen : View {
    
    @EnvironmentObject var list: ShoppingList
    @State var text: String = ""
    
    var body: some View {
        
        List {
            
            HStack {
                TextField("Add new item", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add") {
                    self.createItem()
                }
                .foregroundColor(.blue)
            }
            
            if !self.list.items.pending.isEmpty {
                SectionItemsView(title: "Pending",
                                 items: self.list.items.pending, onTap: self.onTap,
                                 onDelete: self.onDelete)
            }
            
            if !self.list.items.purchased.isEmpty {
                SectionItemsView(title: "Done",
                                 items: self.list.items.purchased,
                                 onTap: self.onTap, onDelete: self.onDelete)
            }
        }
        .listStyle(.insetGrouped)
        .onAppear {
            self.list.startListener()
        }
        .onDisappear {
            self.list.stopListener()
        }
    }
    
    func createItem() {
        guard !self.text.isEmpty else {
            return
        }
        
        let item = Item(id: UUID().uuidString,
                        text: self.text,
                        isDone: false,
                        updatedBy: "Ilya",
                        updatedAt: Date())
        self.list.addItem(item)
        self.text = ""
    }
    
    func onTap(item: Item) {
        self.list.updateItem(item)
    }
    
    func onDelete(item: Item) {
        self.list.removeItem(item)
    }
}

struct SectionItemsView: View {
    
    var title: String
    var items: [Item]
    var onTap: ((Item) -> Void)
    var onDelete: ((Item) -> Void)
    
    var body: some View {
        Section(header: Text(title)) {
            ForEach(self.items, id: \.diff) { item in
                Button(action: {
                    self.onTap(item)
                }) {
                    HStack {
                        Text(item.text)
                        Spacer()
                        Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    }
                }
            }
            .onDelete { (indexSet) in
                indexSet.forEach {
                    self.onDelete(self.items[$0])
                }
            }
        }
    }
}

struct TodoScreen_Previews : PreviewProvider {
    static var previews: some View {
        TodoScreen()
    }
}
