import SwiftUI

struct TabBarView: View {
    @Environment(\.scenePhase) var scenePhase
    @Binding var cards: [Card]
    @State private var selectedCard: Card?
    @State private var timer: Timer?

    var body: some View {
        TabView {
            MachinesTabView(selectedCard: $selectedCard, cards: $cards)
                .tabItem {
                    Label("машинки", systemImage: "washer")
                }
                .onAppear {
                    startFetchingData() 
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
    
    func saveCardsToUserDefaults(_ cards: [Card]) {
        let cardsData = cards.map { ["id": "\($0.id)", "isAvailable": $0.isAvailable ? "true" : "false", "price": "\($0.price)"] }
        UserDefaults.standard.set(cardsData, forKey: "cachedCards")
    }
}
