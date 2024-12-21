import SwiftUI
import CoreData

struct TabBarView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel: TabBarViewModel
    @State private var selectedCard: Card?

    init(cards: [Card] = [], viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: TabBarViewModel(cards: cards, viewContext: viewContext))
    }

    var body: some View {
        ZStack {
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

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            viewModel.selectedTab = 0
                        }
                    }) {
                        VStack {
                            Image(systemName: "washer")
                                .font(.system(size: 24))
                        }
                        .padding()
                        .foregroundColor(viewModel.selectedTab == 0 ? .blue : .gray)
                    }
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            viewModel.selectedTab = 1
                        }
                    }) {
                        VStack {
                            Image(systemName: "star")
                                .font(.system(size: 24))
                        }
                        .padding()
                        .foregroundColor(viewModel.selectedTab == 1 ? .blue : .gray)
                    }
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            viewModel.selectedTab = 2
                        }
                    }) {
                        VStack {
                            Image(systemName: "gear")
                                .font(.system(size: 24))
                        }
                        .padding()
                        .foregroundColor(viewModel.selectedTab == 2 ? .blue : .gray)
                    }
                    Spacer()
                }
                .frame(width: 250, height: 60)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.startFetchingData()
            } else if newPhase == .background {
                viewModel.stopFetchingData()
            }
        }
    }
}

