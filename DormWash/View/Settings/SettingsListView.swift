import SwiftUI

struct SettingsListView: View {
    var body: some View {
        List {
            Section {
                ContactDeveloperButton()
                RateAppButton()
            }
        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
    }
}
