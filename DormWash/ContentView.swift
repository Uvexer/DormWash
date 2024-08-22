import SwiftUI

struct ContentView: View {
    @State private var cards: [Card] = []

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        TabView {
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
            .tabItem {
                Label("Cards", systemImage: "square.grid.2x2")
            }
            .onAppear {
                print("View appeared, starting fetchData")
                NetworkManager.fetchData { fetchedCards in
                    self.cards = fetchedCards
                }
            }

            Text("Second Tab Content")
                .tabItem {
                    Label("Second Tab", systemImage: "star")
                }

            Text("Third Tab Content")
                .tabItem {
                    Label("Third Tab", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
