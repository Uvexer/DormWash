import SwiftUI

struct SettingsListView: View {
    var body: some View {
        List {
            Section {
                AllOrderView()
                ContactDeveloperButton()
                RateAppButton()
            }
        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
    }
}
