import Foundation

struct OrderModel: Identifiable, Hashable {
    let id: Int64
    var machine: String
    var hour: Int
    var minute: Int
    var isAvailable: Bool
    var price: Int64
    
    init(from order: Order) {
        self.id = order.id
        self.machine = order.machine ?? ""
        self.hour = Int(order.hour)
        self.minute = Int(order.minute)
        self.isAvailable = order.isAvailable
        self.price = order.price
    }
}

