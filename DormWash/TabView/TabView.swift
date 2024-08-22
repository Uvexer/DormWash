import SwiftUI

struct TabBarView: View {
    @State private var cards: [Card] = []
    @State private var timer: Timer?

    var body: some View {
        TabView {
            MachinesTabView(cards: $cards)
                .tabItem {
                    Label("машинки", systemImage: "washer")
                }
                .onAppear {
                    startFetchingData()
                }
                .onDisappear {
                    stopFetchingData()
                }

            OrdersTabView()
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
        NetworkManager.fetchData { fetchedCards in
            self.cards = fetchedCards
        }

        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            NetworkManager.fetchData { fetchedCards in
                self.cards = fetchedCards
            }
        }
    }

    func stopFetchingData() {
        timer?.invalidate()
        timer = nil
    }
}

