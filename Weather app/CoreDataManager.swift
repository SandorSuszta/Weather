import Foundation
import CoreData

final class RecentSearchManager {
    
    private let container: NSPersistentContainer
    
    private var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    //MARK: - Init
    
    init() {
        container = NSPersistentContainer(name: "RecentSearch")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    //MARK: - API
    
}
