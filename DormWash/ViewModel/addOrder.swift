import CoreData

extension MachineSelectionView {
    func addOrder(id: Int64, isAvailable: Bool, price: Int64, in context: NSManagedObjectContext) {
        assert(id > 0, "ID должен быть положительным числом")
        assert(price >= 0, "Цена не может быть отрицательной")

        let newOrder = Order(context: context)
        newOrder.id = id
        newOrder.isAvailable = isAvailable
        newOrder.price = price

        print("Context: \(context)")
        print("Order entity: \(newOrder)")
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error: \(nsError)")
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
