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
    
    func save(_ query: String) {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failed to save recent search: \(error)")
            }
        }
    }
    
    func getRecentSearches() -> [String] {
        let fetchRequest = RecentSearch.fetchRequest()
        fetchRequest.fetchLimit = 10
        
        do {
            let recentSearches = try context.fetch(fetchRequest)
            
            return recentSearches.map { $0.query ?? "" }
        } catch {
            fatalError("Failed to fetch recent searches: \(error)")
        }
    }
}