import SwiftUI
import CoreData

@main
struct DormWashApp: App {
    // Создаем экземпляр PersistenceController, который будет управлять Core Data
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
