import SwiftUI

struct ContentView: View {
    @State private var cards: [Card]
    var body: some View {
        TabBarView(cards: cards, viewContext: PersistenceController.shared.container.viewContext)
    }
}
