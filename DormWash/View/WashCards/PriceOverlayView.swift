import SwiftUI

struct PriceOverlayView: View {
    let price: Int
    let isAvailable: Bool

    var body: some View {
        Text("\(price) ₽")
            .font(.caption)
            .padding(7)
            .background(Color(isAvailable ? .green : .red))
            .cornerRadius(10)
            .foregroundColor(.white)
            .offset(x: -10, y: 10)
    }
}
