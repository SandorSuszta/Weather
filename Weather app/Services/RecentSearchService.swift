import Foundation
import CoreData

final class RecentSearchService {
    static let shared = RecentSearchService()
    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return container.viewContext
    }
    // MARK: - Init
    private init() {
        container = NSPersistentContainer(name: "RecentSearch")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    // MARK: - API
    func save(_ query: String) {
        let recentSearch = RecentSearch(context: context)
        recentSearch.query = query
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
        do {
            let recentSearches = try context.fetch(fetchRequest)
            return recentSearches.map { $0.query ?? "" }
        } catch {
            fatalError("Failed to fetch recent searches: \(error)")
        }
    }
}
