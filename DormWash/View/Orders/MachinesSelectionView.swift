import SwiftUI

struct MachinesSelectionView: View {
    @ObservedObject var viewModel: OrdersViewModel

    var body: some View {
        VStack {
            Text("Выбери машинку")
                .font(.largeTitle)

            Picker("Выберите машинку", selection: $viewModel.selectedMachine) {
                ForEach(viewModel.machines, id: \.self) { machine in
                    Text(machine)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

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
