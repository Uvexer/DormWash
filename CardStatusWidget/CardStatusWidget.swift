import WidgetKit
import SwiftUI

struct CardEntry: TimelineEntry {
    let date: Date
    let availableCount: Int
}

struct CardProvider: TimelineProvider {
    func placeholder(in context: Context) -> CardEntry {
        CardEntry(date: Date(), availableCount: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CardEntry) -> ()) {
        let entry = CardEntry(date: Date(), availableCount: fetchAvailableCardsCount())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CardEntry>) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Задержка на 1 секунду
            var entries: [CardEntry] = []
            
            let currentDate = Date()
            for hourOffset in 0..<24 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset * 10, to: currentDate)!
                let entry = CardEntry(date: entryDate, availableCount: fetchAvailableCardsCount())
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    
    let userDefaults = UserDefaults(suiteName: "group.com.ghghg.DormWash")
    func fetchAvailableCardsCount() -> Int {
        guard let savedCardsData = UserDefaults.standard.array(forKey: "cachedCards") as? [[String: String]] else {
            print("Нет данных в UserDefaults")
            return 0
        }
        
        let availableCards = savedCardsData.filter { dict in
            dict["isAvailable"] == "true"
        }
        
        print("Доступные карточки: \(availableCards.count)")
        
        return availableCards.count
    }
    
}
