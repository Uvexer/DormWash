import CoreData
import Foundation

class TabBarViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var selectedTab: Int = 0
    private var timer: Timer?
    let viewContext: NSManagedObjectContext

    init(cards: [Card] = [], viewContext: NSManagedObjectContext) {
        self.cards = cards
        self.viewContext = viewContext
    }

    func startFetchingData() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.fetchData()
        }
    }

    func stopFetchingData() {
        timer?.invalidate()
        timer = nil
    }

    private func fetchData() {
        NetworkManager.fetchData { fetchedCards in
            DispatchQueue.main.async {
                self.cards = fetchedCards
                self.saveCardsToUserDefaults(fetchedCards)
            }
        }
    }

    private func saveCardsToUserDefaults(_ cards: [Card]) {
        let cardsData = cards.map { ["id": "\($0.id)", "isAvailable": $0.isAvailable ? "true" : "false", "price": "\($0.price)"] }
        UserDefaults.standard.set(cardsData, forKey: "cachedCards")
    }
}
