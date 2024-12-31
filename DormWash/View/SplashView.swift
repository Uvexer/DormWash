import SwiftUI

struct SplashView: View {
    @Binding var isDataLoaded: Bool
    @Binding var cards: [Card]
    @State private var fadeIn = false
    @State private var scaleEffect = 0.8

    var body: some View {
        VStack {
            Image(systemName: "washer.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .opacity(fadeIn ? 1 : 0)
                .scaleEffect(scaleEffect)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) {
                        fadeIn = true
                        scaleEffect = 1.0
                    }

                    NetworkManager.fetchData { fetchedCards in
                        cards = fetchedCards
                        saveCardsToUserDefaults(fetchedCards)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                isDataLoaded = true
                            }
                        }
                    }
                }
        }
    }

    func saveCardsToUserDefaults(_ cards: [Card]) {
        let cardsData = cards.map { ["id": "\($0.id)", "isAvailable": $0.isAvailable ? "true" : "false", "price": "\($0.price)"] }
        UserDefaults.standard.set(cardsData, forKey: "cachedCards")
    }
}
