import SwiftUI

struct TabBarView: View {
    @Environment(\.scenePhase) var scenePhase
    @Binding var cards: [Card]
    @State private var selectedCard: Card?
    @State private var timer: Timer?
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
           
            switch selectedTab {
            case 0:
                MachinesTabView(selectedCard: $selectedCard, cards: $cards)
                    .onAppear { startFetchingData() }
                    .onDisappear { stopFetchingData() }
            case 1:
                OrdersTabView()
            case 2:
                SettingsTabView()
            default:
                MachinesTabView(selectedCard: $selectedCard, cards: $cards)
            }
            
           
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                   
                    Button(action: {
                        selectedTab = 0
                    }) {
                        VStack {
                            Image(systemName: "washer")
                           
                        }
                        .padding()
                        .foregroundColor(selectedTab == 0 ? .blue : .gray)
                    }
                    Spacer()
                    
                   
                    Button(action: {
                        selectedTab = 1
                    }) {
                        VStack {
                            Image(systemName: "star")
                            
                        }
                        .padding()
                        .foregroundColor(selectedTab == 1 ? .blue : .gray)
                    }
                    Spacer()
                    
                   
                    Button(action: {
                        selectedTab = 2
                    }) {
                        VStack {
                            Image(systemName: "gear")
                           
                        }
                        .padding()
                        .foregroundColor(selectedTab == 2 ? .blue : .gray)
                    }
                    Spacer()
                }
                .frame(width: 250, height: 60)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
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
