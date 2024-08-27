import SwiftUI
import WidgetKit
@main
struct CardStatusWidget: Widget {
    let kind: String = "CardStatusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CardProvider()) { entry in
            CardStatusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Статус Карточек")
        .description("Показывает количество свободных карточек.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}


