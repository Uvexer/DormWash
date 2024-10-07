import SwiftUI

struct SplashView: View {
    @Binding var isDataLoaded: Bool
    @Binding var cards: [Card]

    var body: some View {
        VStack {
            Text("Loading...")
                .font(.largeTitle)
                .onAppear {
                  
                    NetworkManager.fetchData { fetchedCards in
                        self.cards = fetchedCards
                        saveCardsToUserDefaults(fetchedCards)
                       
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isDataLoaded = true
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
