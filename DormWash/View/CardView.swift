import SwiftUI

struct CardView: View {
    let card: Card
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .stroke(card.isAvailable ? Color.green : Color.red, lineWidth: 3)
                    .frame(width: 60, height: 60)
                
                if !card.isAvailable {
                    SpinningDrumView()
                        .frame(width: 40, height: 40)
                }

                Text("\(card.id)")
                    .foregroundColor(.black)
                    .font(.headline)
            }
            
            Spacer()
            Text(card.isAvailable ? "Свободно" : "Занято")
                .foregroundColor(card.isAvailable ? .green : .red)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 6)
        .overlay(
            priceOverlay,
            alignment: .topTrailing
        )
    }
    
    private var priceOverlay: some View {
        Text("\(card.price) ₽")
            .font(.caption)
            .padding(7)
            .background(Color(card.isAvailable ? .green : .red))
            .cornerRadius(10)
            .foregroundColor(.white)
            .offset(x:-10, y: 10)
    }
}

