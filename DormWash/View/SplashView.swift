import Lottie
import SwiftUI

struct SplashView: View {
    @Binding var isDataLoaded: Bool
    @Binding var cards: [Card]
    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack {
            Spacer()
            LottieView(animation: .named("WaterAnimation"))
                .playing()
                .looping()
                .frame(width: 200, height: 200)
                .scaledToFit()
                .onAppear {
                    scale = 1.2

                    NetworkManager.fetchData { fetchedCards in
                        cards = fetchedCards
                        saveCardsToUserDefaults(fetchedCards)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isDataLoaded = true
                        }
                    }
                }
            Spacer()
            Text("Powered by Bögd")
                .font(.headline)
        }
        .frame(alignment: .center)
    }

    func saveCardsToUserDefaults(_ cards: [Card]) {
        let cardsData = cards.map { ["id": "\($0.id)", "isAvailable": $0.isAvailable ? "true" : "false", "price": "\($0.price)"] }
        UserDefaults.standard.set(cardsData, forKey: "cachedCards")
    }
}

struct SplashView2: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color.white.opacity(0.5)
                .ignoresSafeArea(edges: .all)

            VStack {
                Spacer()
                LottieView(animation: .named("WaterAnimation"))
                    .playing()
                    .looping()
                    .frame(width: 200, height: 200)
                    .scaledToFit()

                Spacer()
                Text("Powered by Bögd")
                    .font(.headline)
            }
            .frame(alignment: .center)
        }
    }
}

#Preview {
    SplashView2()
}
