import SwiftUI
import WidgetKit
@main
struct CardsWidget: Widget {
    let kind: String = "CardsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CardsWidgetProvider()) { entry in
            CardsWidgetView(entry: entry)
        }
        .configurationDisplayName("Available Cards")
        .description("Shows the number of available cards.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}


