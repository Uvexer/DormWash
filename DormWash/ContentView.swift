import SwiftUI

struct ContentView: View {
    @State private var cards: [Card] = []

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
                    }
                }
                .padding()
            }
        }
        .onAppear {
            print("View appeared, starting fetchData")
            NetworkManager.fetchData { fetchedCards in
                self.cards = fetchedCards
            }
        }
    }
}

#Preview {
    ContentView()
}
