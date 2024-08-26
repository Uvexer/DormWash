import SwiftUI

struct TabBarView: View {
    @State private var cards: [Card] = []
    @State private var selectedCard: Card? 
    @State private var timer: Timer?

    var body: some View {
        TabView {
            MachinesTabView(selectedCard: $selectedCard, cards: $cards)
                .tabItem {
                    Label("машинки", systemImage: "washer")
                }
                .onAppear {
                    if cards.isEmpty {
                        cards = loadCardsFromUserDefaults()
                        startFetchingData()
                    }
                }
                .onDisappear {
                    stopFetchingData()
                }

            OrdersTabView(cards: $cards)
                .tabItem {
                    Label("Заказы", systemImage: "star")
                }

            SettingsTabView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
        }
    }

    func startFetchingData() {
        NetworkManager.fetchData { fetchedCards, availableCount in
            self.cards = fetchedCards
            saveCardsToUserDefaults(fetchedCards)
        

        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            NetworkManager.fetchData { fetchedCards, availableCount in
                self.cards = fetchedCards
                saveCardsToUserDefaults(fetchedCards)
            }
        }
    }

        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            NetworkManager.fetchData { fetchedCards, availableCount in
                self.cards = fetchedCards
                saveCardsToUserDefaults(fetchedCards)
            }
        }
    }

    func stopFetchingData() {
        timer?.invalidate()
        timer = nil
    }
    
    func saveCardsToUserDefaults(_ cards: [Card]) {
        let cardsData = cards.map { ["id": "\($0.id)", "isAvailable": $0.isAvailable ? "true" : "false", "price": "\($0.price)"] }
        UserDefaults.standard.set(cardsData, forKey: "cachedCards")
    }
    
    func loadCardsFromUserDefaults() -> [Card] {
        guard let savedCardsData = UserDefaults.standard.array(forKey: "cachedCards") as? [[String: String]] else {
            return []
        }

        return savedCardsData.compactMap { dict in
            guard let idString = dict["id"],
                  let id = Int(idString),
                  let isAvailableString = dict["isAvailable"],
                  let isAvailable = Bool(isAvailableString),
                  let priceString = dict["price"],
                  let price = Int(priceString) else {
                return nil
            }
            return Card(id: id, isAvailable: isAvailable, price: price)
        }
    }
}
