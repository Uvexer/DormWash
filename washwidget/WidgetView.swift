import WidgetKit
import SwiftUI

struct WashWidgetEntryView: View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            Text("Свободно \(entry.freeCardsCount)")
                .font(.headline)
                .padding()
        case .systemMedium:
            VStack(alignment: .leading) {
                Text("Свободные карточки")
                    .font(.headline)
                Spacer()
                Text("\(entry.freeCardsCount)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding()
        case .systemLarge:
            VStack(alignment: .leading) {
                Text("Свободные карточки")
                    .font(.headline)
                Spacer()
                Text("\(entry.freeCardsCount)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Text("Обновлено: \(entry.date, formatter: dateFormatter)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
        default:
            Text("Свободно \(entry.freeCardsCount)")
                .font(.headline)
                .padding()
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

