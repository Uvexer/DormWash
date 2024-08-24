import CoreData

import CoreData

extension MachineSelectionView {
     func addOrder(id: Int64, isAvailable: Bool, price: Int64, in context: NSManagedObjectContext) {
        assert(id > 0, "ID должен быть положительным числом")
        assert(price >= 0, "Цена не может быть отрицательной")

        let newOrder = Order(context: context)
        newOrder.id = id
        newOrder.isAvailable = isAvailable
        newOrder.price = price

        do {
            try context.save()
            print("Order saved successfully")
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
