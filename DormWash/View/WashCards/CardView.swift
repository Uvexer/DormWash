import SwiftUI

struct CardView: View {
    let card: Card
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Spacer()
            CardStatusView(card: card)
            Spacer()
            AvailabilityTextView(isAvailable: card.isAvailable)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 6)
        .overlay(PriceOverlayView(price: card.price, isAvailable: card.isAvailable), alignment: .topTrailing)
    }
}

