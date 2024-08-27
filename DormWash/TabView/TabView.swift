import SwiftUI

struct TabBarView: View {
    @Environment(\.scenePhase) var scenePhase
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
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                startFetchingData()
            } else if newPhase == .background {
                stopFetchingData()
            }
        }
    }

    func startFetchingData() {
        NetworkManager.fetchData { fetchedCards in
            self.cards = fetchedCards
            saveCardsToUserDefaults(fetchedCards)
        }

        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            NetworkManager.fetchData { fetchedCards in
                self.cards = fetchedCards
                saveCardsToUserDefaults(fetchedCards)
            }
        }
    }

    func stopFetchingData() {
        timer?.invalidate()
        timer = nil
    }
    
    let userDefaults = UserDefaults(suiteName: "group.com.ghghg.DormWash")
    func saveCardsToUserDefaults(_ cards: [Card]) {
        let cardsData = cards.map { ["id": "\($0.id)", "isAvailable": $0.isAvailable ? "true" : "false", "price": "\($0.price)"] }
        userDefaults?.set(cardsData, forKey: "cachedCards")
        userDefaults?.synchronize()

        if let savedData = userDefaults?.array(forKey: "cachedCards") {
            print("Данные успешно сохранены: \(savedData)")
        } else {
            print("Не удалось сохранить данные в UserDefaults")
        }
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
