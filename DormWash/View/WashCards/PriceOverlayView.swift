import CoreData
import SwiftUI

struct PriceOverlayView: View {
    let viewContext = PersistenceController.shared.container.viewContext
    let price: Int
    let isAvailable: Bool

    @State private var isMachinesSelectionPresented = false

    var body: some View {
        HStack {
            Text("\(price) ₽")
                .font(.caption)
                .padding(7)
                .background(Color(isAvailable ? .green : .red))
                .cornerRadius(10)
                .foregroundColor(.white)
                .offset(x: 10, y: 10)

            Spacer()

            TimerView {
                isMachinesSelectionPresented.toggle()
            }
        }
        .sheet(isPresented: $isMachinesSelectionPresented) {
            MachinesSelectionView(viewModel: OrdersViewModel(viewContext: viewContext))
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

struct TimerView: View {
    var onTap: () -> Void

    var body: some View {
        Button(action: {
            onTap()
        }) {
            Image(systemName: "plus.circle")
                .foregroundStyle(Color.black.opacity(0.6))
                .font(.title2)
                .padding(7)
                .offset(x: -10, y: 10)
        }
    }
}
