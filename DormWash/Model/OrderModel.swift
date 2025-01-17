import Foundation

struct OrderModel: Identifiable, Hashable {
    let id: Int64
    var machine: String
    var hour: Int
    var minute: Int
    var second: Int
    var isAvailable: Bool
    var price: Int64
    var creationDate: Date
    var identifier: String

    init(from order: Order) {
        id = order.id
        machine = order.machine ?? ""
        hour = Int(order.hour)
        minute = Int(order.minute)
        second = Int(order.second)
        isAvailable = order.isAvailable
        price = order.price
        creationDate = order.creationDate ?? Date()
        identifier = order.identifier ?? UUID().uuidString
    }
}
