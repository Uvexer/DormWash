import SwiftUI

struct ContentView: View {
    @State var cards: [Card]
    var body: some View {
        TabBarView(cards: cards, viewContext: PersistenceController.shared.container.viewContext)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let mockCards = [
            Card(id: 1, isAvailable: true, price: 100),
            Card(id: 2, isAvailable: false, price: 200),
            Card(id: 3, isAvailable: true, price: 150),
        ]

        ContentView(cards: mockCards)
    }
}
