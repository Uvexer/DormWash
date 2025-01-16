import SwiftUI

struct MainContentView: View {
    @ObservedObject var viewModel: TabBarViewModel
    @Binding var selectedCard: Card?

    var body: some View {
        ZStack {
            MachinesTabView(selectedCard: $selectedCard, cards: $viewModel.cards)
                .opacity(viewModel.selectedTab == 0 ? 1 : 0)
                .onAppear { if viewModel.selectedTab == 0 { viewModel.startFetchingData() } }
                .onDisappear { if viewModel.selectedTab == 0 { viewModel.stopFetchingData() } }

            OrdersTabView(viewContext: viewModel.viewContext)
                .opacity(viewModel.selectedTab == 1 ? 1 : 0)

            AchieveView(viewContext: viewModel.viewContext)
                .opacity(viewModel.selectedTab == 2 ? 1 : 0)
        }
    }
}
