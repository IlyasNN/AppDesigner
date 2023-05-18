import Foundation
import CoreData

// MARK: EntitiesEnum

enum Entities {
    case currentUser(_ model: User? = nil)}

// MARK: Context

enum Context {
    case view
    case specific(NSManagedObjectContext)
    
    var context: NSManagedObjectContext {
        switch self {
        case .view:
            return CoreDataManager.viewContext
        case .specific(let specificContext):
            return specificContext
        }
    }
}

// MARK: ChangesEnum

enum CoreDataChanges<T>: Equatable {
    
    static func == (lhs: CoreDataChanges<T>, rhs: CoreDataChanges<T>) -> Bool {
        return false
    }
    
    case insert(IndexPath, T)
    case update(IndexPath, T)
    case delete(IndexPath, T?)
    case initial([T])
}

// MARK: ManagerProtocol

protocol CoreDataManagerProtocol {
    
    static var shared: CoreDataManager { get }
    
    // general methods
    
    func getEntity(entity: Entities, id: String, contextType: Context) -> NSManagedObject?
    func getEntities(entity: Entities, contextType: Context) -> [NSManagedObject]?
    func addEntity(entity: Entities, contextType: Context)
    func removeEntity(entity: Entities, id: String?, contextType: Context)
    
    // Stack
    
    static var viewContext: NSManagedObjectContext { get }
    static func saveViewContext()
    
    static func newBackgroundContext() -> NSManagedObjectContext
    static func saveContext(_ context: NSManagedObjectContext)
}

// MARK: General

class CoreDataManager: NSObject, CoreDataManagerProtocol {
    
    // MARK: Singleton
    static let shared = CoreDataManager()
    private override init() {
        super.init()
        
    }
    
    // MARK: General methods
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: CoreDataManager.viewContext)!
    }
    
    func getEntity(entity: Entities, id: String, contextType: Context) -> NSManagedObject? {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        
        let context = contextType.context
        
        switch entity {
        case .currentUser:
            fetchRequest = CurrentUserEntity.fetchRequest()
        }
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try context.fetch(fetchRequest)
            if objects.isEmpty {
                return nil
            }
            return objects[0] as? NSManagedObject
        } catch {
            let fetchError = error as NSError
            print("Unable to Delete Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        return nil
    }
    
    func getEntities(entity: Entities, contextType: Context) -> [NSManagedObject]? {
        
        let context = contextType.context
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        
        switch entity {
        case .currentUser:
            fetchRequest = CurrentUserEntity.fetchRequest()
        }
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try context.fetch(fetchRequest)
            if objects.isEmpty {
                return nil
            }
            return objects as? [NSManagedObject]
        } catch {
            print(error)
            print(error.localizedDescription)
        }
        return nil
    }
    
    func addEntity(entity: Entities, contextType: Context) {
        
        let context = contextType.context
        
        switch entity {
        case .currentUser:
            //            guard let model = model else {
            //                return
            //            }
            break
        }
        CoreDataManager.saveContext(context)
    }
    
    func removeEntity(entity: Entities, id: String?, contextType: Context) {
        
        let context = contextType.context
        
        switch entity {
        case .currentUser:
            let currentUsers = getEntities(entity: .currentUser(), contextType: contextType)
            currentUsers?.forEach(context.delete)
        }
        
        CoreDataManager.saveContext(context)
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ShoppingListCoreData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var viewContext = CoreDataManager.persistentContainer.viewContext
    static func newBackgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = viewContext
        return context
    }
    
    static func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
                if let parentContext = context.parent {
                    saveContext(parentContext)
                }
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    static func saveViewContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
