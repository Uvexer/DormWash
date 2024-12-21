import SwiftUI

struct AvailabilityTextView: View {
    let isAvailable: Bool

    var body: some View {
        Text(isAvailable ? "Свободно" : "Занято")
            .foregroundColor(isAvailable ? .green : .red)
    }
}
