import CoreData
import SwiftUI

struct AchieveCardView: View {
    let stepValue: Int
    @StateObject private var ordersViewModel: OrdersViewModel

    init(viewContext: NSManagedObjectContext, stepValue: Int) {
        _ordersViewModel = StateObject(wrappedValue: OrdersViewModel(viewContext: viewContext))
        self.stepValue = stepValue
    }

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.6))
                .frame(width: 160, height: 160)
                .overlay(
                    VStack {
                        Image(systemName: "washer")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 50, maxHeight: 50)
                            .foregroundColor(.blue.opacity(0.9))
                            .opacity(
                                ordersViewModel.fetchCurrentValue() >= stepValue ? 1.0 : 0.3
                            )
                        Text("сделано стирок")
                        Text("\(ordersViewModel.fetchCurrentValue()) из \(stepValue)")
                            .font(.subheadline)
                    }
                )
        }
    }
}

#Preview {
    let viewContext = PersistenceController.shared.container.viewContext
    AchieveView(viewContext: viewContext)
}
