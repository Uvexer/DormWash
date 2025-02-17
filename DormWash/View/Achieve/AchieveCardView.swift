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
        VStack(alignment: .center, spacing: 10) {
            Image(systemName: "washer")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50, maxHeight: 50)
                .foregroundColor(.white)
                .opacity(
                    ordersViewModel.fetchCurrentValue() >= stepValue ? 1.0 : 0.3
                )

            VStack(alignment: .center, spacing: 5) {
                Text("ты чистый")
                    .multilineTextAlignment(.center)
                Text("\(ordersViewModel.fetchCurrentValue()) из \(stepValue)")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

#Preview {
    let viewContext = PersistenceController.shared.container.viewContext
    AchieveView(viewContext: viewContext)
}
