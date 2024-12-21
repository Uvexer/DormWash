import SwiftUI

struct MainContentView: View {
    @ObservedObject var viewModel: TabBarViewModel
    @Binding var selectedCard: Card?

    var body: some View {
        switch viewModel.selectedTab {
        case 0:
            MachinesTabView(selectedCard: $selectedCard, cards: $viewModel.cards)
                .onAppear { viewModel.startFetchingData() }
                .onDisappear { viewModel.stopFetchingData() }
        case 1:
            OrdersTabView(viewContext: viewModel.viewContext)
        case 2:
            SettingsTabView()
        default:
            MachinesTabView(selectedCard: $selectedCard, cards: $viewModel.cards)
        }
    }
}
