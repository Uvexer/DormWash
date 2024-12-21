import SwiftUI

struct CardStatusView: View {
    let card: Card

    var body: some View {
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
    }
}
