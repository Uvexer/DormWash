import SwiftUI

struct MachinesSelectionView: View {
    @ObservedObject var viewModel: OrdersViewModel

    var body: some View {
        VStack {
            Text("Выбери время заказа")
                .font(.largeTitle)

            TimePickerView(viewModel: viewModel)

            Button(action: {
                viewModel.addOrder()
                if let latestOrder = viewModel.orders.last {
                    viewModel.scheduleNotification(for: latestOrder)
                }
                viewModel.showMachineSelection = false
            }) {
                Text("Добавить")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}
