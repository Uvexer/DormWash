import SwiftUI

struct ContentView: View {
    @State private var cards: [Card] = []
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(cards) { card in
                    HStack {
                        Text("Card \(card.id)")
                        Spacer()
                        Text(card.isAvailable ? "Свободно" : "Занято")
                    }
                    .padding()
                    .background(card.isAvailable ? Color.green : Color.red)
                    .cornerRadius(10)
                }
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
