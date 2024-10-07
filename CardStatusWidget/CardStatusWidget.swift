import WidgetKit
import SwiftUI
import Combine

struct CardsWidgetEntry: TimelineEntry {
    let date: Date
    let availableCardsCount: Int
}

struct CardsWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> CardsWidgetEntry {
        CardsWidgetEntry(date: Date(), availableCardsCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (CardsWidgetEntry) -> ()) {
        let entry = CardsWidgetEntry(date: Date(), availableCardsCount: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CardsWidgetEntry>) -> ()) {
        NetworkManager.fetchData { fetchedCards in
            let availableCardsCount = fetchedCards.filter { $0.isAvailable }.count
            let entry = CardsWidgetEntry(date: Date(), availableCardsCount: availableCardsCount)

         
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}

struct CardsWidgetView: View {
    var entry: CardsWidgetProvider.Entry

    var body: some View {
        VStack {
            Text("Свободно Стиралок")
                .font(.headline)
            Text("\(entry.availableCardsCount - 1)")
                .font(.largeTitle)
                .bold()
        }
        .padding()
        .containerBackground(.regularMaterial, for: .widget)
    }
}
