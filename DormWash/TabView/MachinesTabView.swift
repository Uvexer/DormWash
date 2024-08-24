import SwiftUI

struct MachinesTabView: View {
    @Binding var selectedCard: Card?
    @Binding var cards: [Card]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(cards) { card in
                        CardView(card: card)
                            .onTapGesture {
                                selectedCard = card
                            }
                    }
                }
                .padding()
            }
        }
    }
}
