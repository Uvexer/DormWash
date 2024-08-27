import SwiftUI
import WidgetKit

struct CardStatusWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: CardProvider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            Text("Свободно: \(entry.availableCount)")
                .font(.system(size: 16))
                .padding()
                .containerBackground(for: .widget) {
                    Color(.systemBackground)
                }
        case .systemMedium:
            VStack {
                Text("Свободно: \(entry.availableCount) карточек")
                    .font(.system(size: 20))
                Text("Обновлено: \(entry.date, style: .time)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding()
            .containerBackground(for: .widget) {
                Color(.systemBackground)
            }
        case .systemLarge:
            VStack {
                Text("Свободно: \(entry.availableCount) карточек")
                    .font(.system(size: 24))
                Text("Последнее обновление: \(entry.date, style: .time)")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding()
            .containerBackground(for: .widget) {
                Color(.systemBackground)
            }
        @unknown default:
            Text("Свободно: \(entry.availableCount)")
                .containerBackground(for: .widget) {
                    Color(.systemBackground)
                }
        }
    }
}

struct CardStatusWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardStatusWidgetEntryView(entry: CardEntry(date: Date(), availableCount: 5))
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            CardStatusWidgetEntryView(entry: CardEntry(date: Date(), availableCount: 10))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            CardStatusWidgetEntryView(entry: CardEntry(date: Date(), availableCount: 20))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

