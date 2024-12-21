import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DormWash")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Ошибка загрузки Core Data: \(error.localizedDescription)")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
}
