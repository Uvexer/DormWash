import Combine
import CoreData
import Foundation
import UserNotifications

class OrdersViewModel: ObservableObject {
    @Published var orders: [OrderModel] = []
    @Published var selectedMachine: String = "Машинка 1"
    @Published var selectedHour: Int = 0
    @Published var selectedMinute: Int = 0
    @Published var showMachineSelection = false

    let machines = ["Машинка 1", "Машинка 2", "Машинка 3", "Машинка 4", "Машинка 5", "Машинка 6", "Машинка 7", "Машинка 8"]
    let hours = Array(0 ..< 24)
    let minutes = Array(0 ..< 60)

    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchOrders()
    }

    func fetchOrders() {
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        do {
            let ordersFetched = try viewContext.fetch(fetchRequest)
            orders = ordersFetched.map { OrderModel(from: $0) }
        } catch {
            print("Ошибка при получении заказов: \(error.localizedDescription)")
        }
    }

    func addOrder() {
        let newOrder = Order(context: viewContext)
        newOrder.id = Int64(orders.count + 1)
        newOrder.machine = selectedMachine
        newOrder.hour = Int16(selectedHour)
        newOrder.minute = Int16(selectedMinute)
        newOrder.isAvailable = true
        newOrder.price = 100

        do {
            try viewContext.save()
            fetchOrders()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func deleteOrder(at offsets: IndexSet) {
        offsets.map { orders[$0] }.forEach { order in
            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", order.id)
            do {
                let fetchedOrders = try viewContext.fetch(fetchRequest)
                if let orderToDelete = fetchedOrders.first {
                    viewContext.delete(orderToDelete)
                    try viewContext.save()
                    fetchOrders()
                }
            } catch {
                print("Ошибка при удалении заказа: \(error.localizedDescription)")
            }
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                print("Разрешение на уведомления получено")
            } else {
                print("Разрешение на уведомления отклонено")
            }
        }
    }

    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Время вышло!"
        content.body = "Ваш заказ для \(selectedMachine) завершен."

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: calculateTimeInterval(), repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Ошибка планирования уведомления: \(error.localizedDescription)")
            }
        }
    }

    private func calculateTimeInterval() -> TimeInterval {
        let currentDate = Date()
        var components = DateComponents()
        components.hour = selectedHour
        components.minute = selectedMinute

        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: components, to: currentDate) ?? currentDate
        return futureDate.timeIntervalSince(currentDate)
    }

    func orderTimeString(for order: OrderModel) -> String {
        let hour = String(format: "%02d", order.hour)
        let minute = String(format: "%02d", order.minute)
        return "\(hour):\(minute)"
    }
}
