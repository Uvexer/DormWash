import CoreData
import SwiftUI

struct TabBarView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel: TabBarViewModel
    @State private var selectedCard: Card?

    init(cards: [Card] = [], viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: TabBarViewModel(cards: cards, viewContext: viewContext))
    }

    var body: some View {
        ZStack {
            MainContentView(viewModel: viewModel, selectedCard: $selectedCard)

            VStack {
                Spacer()
                TabBar(selectedTab: $viewModel.selectedTab)
                    .padding(.horizontal)
            }
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                viewModel.startFetchingData()
            case .background:
                viewModel.stopFetchingData()
            default:
                break
            }
        }
    }
}
