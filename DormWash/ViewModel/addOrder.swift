import CoreData

extension MachineSelectionView {
    func addOrder(id: Int64, isAvailable: Bool, price: Int64, in context: NSManagedObjectContext) {
        let newOrder = Order(context: context)
        newOrder.id = id
        newOrder.isAvailable = isAvailable
        newOrder.price = price
        newOrder.creationDate = Date()

        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении заказа: \(error)")
        }
    }
}
