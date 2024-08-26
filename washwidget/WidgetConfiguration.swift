import WidgetKit
import SwiftUI

@main
struct WashWidget: Widget {
    let kind: String = "WashWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WashWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Wash Widget")
        .description("Shows the number of free cards.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

