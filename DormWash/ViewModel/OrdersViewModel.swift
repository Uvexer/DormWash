import Combine
import CoreData
import Foundation
import UserNotifications

class OrdersViewModel: ObservableObject {
    @Published var orders: [OrderModel] = []
    @Published var selectedMachine: String = "Машинка 1"
    @Published var selectedHour: Int = 0
    @Published var selectedMinute: Int = 1
    @Published var selectedSecond: Int = 0
    @Published var showMachineSelection = false

    let machines = ["Машинка 1", "Машинка 2", "Машинка 3", "Машинка 4", "Машинка 5", "Машинка 6", "Машинка 7", "Машинка 8"]
    let hours = Array(0 ..< 24)
    let minutes = Array(0 ..< 60)
    let seconds = Array(0 ..< 60)

    private let viewContext: NSManagedObjectContext
    private var timer: AnyCancellable?

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchOrders()
        setupTimer()
    }

    deinit {
        timer?.cancel()
    }

    private func setupTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkExpiredOrders()
            }
    }

    func fetchCurrentValue() -> Int {
        UserDefaults.standard.integer(forKey: "currentValue")
    }

    func fetchOrders() {
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        do {
            let ordersFetched = try viewContext.fetch(fetchRequest)
            for order in ordersFetched {
                if order.creationDate == nil {
                    order.creationDate = Date()
                }
            }
            try viewContext.save()
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
        newOrder.second = Int16(selectedSecond)
        newOrder.isAvailable = true
        newOrder.price = 169
        newOrder.creationDate = Date()
        newOrder.identifier = UUID().uuidString

        do {
            try viewContext.save()

            let newCurrentValue = fetchCurrentValue() + 1
            updateCurrentValue(to: newCurrentValue)

            fetchOrders()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func updateCurrentValue(to value: Int) {
        UserDefaults.standard.set(value, forKey: "currentValue")
    }

    func deleteOrder(at offsets: IndexSet) {
        for index in offsets {
            let orderToDelete = orders[index]
            deleteOrderFromContext(withID: orderToDelete.id)
        }
        fetchOrders()
    }

    private func deleteOrderFromContext(withID id: Int64) {
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let fetchedOrders = try viewContext.fetch(fetchRequest)
            if let orderToDelete = fetchedOrders.first {
                viewContext.delete(orderToDelete)
                try viewContext.save()
            }
        } catch {
            print("Ошибка при удалении заказа: \(error.localizedDescription)")
        }
    }

    private func checkExpiredOrders() {
        let currentDate = Date()
        let calendar = Calendar.current

        var expiredOrderIDs: [Int64] = []

        for order in orders {
            var components = DateComponents()
            components.hour = order.hour
            components.minute = order.minute
            components.second = order.second

            if let orderDate = calendar.date(byAdding: components, to: order.creationDate) {
                if currentDate >= orderDate {
                    expiredOrderIDs.append(order.id)
                }
            }
        }

        for id in expiredOrderIDs {
            deleteOrderFromContext(withID: id)
        }

        fetchOrders()
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

    func scheduleNotification(for order: OrderModel) {
        let content = UNMutableNotificationContent()
        content.title = "Время вышло!"
        content.body = "Ваш заказ для \(order.machine) завершен."
        content.sound = .default
        content.userInfo = ["identifier": order.identifier]

        let timeInterval = calculateTimeInterval(for: order)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(identifier: order.identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Ошибка планирования уведомления: \(error.localizedDescription)")
            }
        }
    }

    private func calculateTimeInterval(for order: OrderModel) -> TimeInterval {
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = order.hour
        components.minute = order.minute
        components.second = order.second

        if let futureDate = calendar.date(byAdding: components, to: order.creationDate) {
            return max(0, futureDate.timeIntervalSinceNow)
        }
        return 0
    }

    func orderTimeString(for order: OrderModel) -> String {
        let hour = String(format: "%02d", order.hour)
        let minute = String(format: "%02d", order.minute)
        let second = String(format: "%02d", order.second)
        return "\(hour):\(minute):\(second)"
    }
}
