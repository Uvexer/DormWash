import SwiftUI

struct SplashView: View {
    @Binding var isDataLoaded: Bool
    @Binding var cards: [Card]
    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "washer")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scale)
                .onAppear {
                    scale = 1.2

                    NetworkManager.fetchData { fetchedCards in
                        cards = fetchedCards
                        saveCardsToUserDefaults(fetchedCards)

                        DispatchQueue.main.async {
                            isDataLoaded = true
                        }
                    }
                }
            Spacer()
        }
    }

    func saveCardsToUserDefaults(_ cards: [Card]) {
        let cardsData = cards.map { ["id": "\($0.id)", "isAvailable": $0.isAvailable ? "true" : "false", "price": "\($0.price)"] }
        UserDefaults.standard.set(cardsData, forKey: "cachedCards")
    }
}
