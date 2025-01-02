import SwiftUI

struct SettingsTabView: View {
    var body: some View {
        ZStack {
            Color.clear
                .animatedGradientBackground()

            VStack {
                HeaderView()

                SettingsListView()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
