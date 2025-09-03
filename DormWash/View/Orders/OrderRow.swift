import SwiftUI

struct OrderRow: View {
    let order: OrderModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(order.machine)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    Text(timeString)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }

                Text(order.isAvailable ? "Доступно" : "Недоступно")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(order.isAvailable ? .green : .red)
            }

            Spacer()

            VStack {
                Text("\(order.price) ₽")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                Image(systemName: order.isAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(order.isAvailable ? .green : .red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        )
    }

    private var timeString: String {
        let hour = String(format: "%02d", order.hour)
        let minute = String(format: "%02d", order.minute)
        return "\(hour):\(minute)"
    }
}
