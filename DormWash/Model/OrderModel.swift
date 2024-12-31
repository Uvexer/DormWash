import Foundation

struct OrderModel: Identifiable, Hashable {
    let id: Int64
    var machine: String
    var hour: Int
    var minute: Int
    var isAvailable: Bool
    var price: Int64

    init(from order: Order) {
        id = order.id
        machine = order.machine ?? ""
        hour = Int(order.hour)
        minute = Int(order.minute)
        isAvailable = order.isAvailable
        price = order.price
    }
}
