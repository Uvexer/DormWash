import CoreData
import SwiftUI

struct OrdersTabView: View {
    @StateObject private var viewModel: OrdersViewModel

    init(viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: OrdersViewModel(viewContext: viewContext))
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .animatedGradientBackground()

                VStack {
                    OrdersListView(viewModel: viewModel)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AddOrderButton(viewModel: viewModel)
                }
            }
            .sheet(isPresented: $viewModel.showMachineSelection) {
                MachinesSelectionView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.requestNotificationPermission()
            }
        }
    }
}
