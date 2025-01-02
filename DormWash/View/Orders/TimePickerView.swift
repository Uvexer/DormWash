import SwiftUI

struct TimePickerView: View {
    @ObservedObject var viewModel: OrdersViewModel

    var body: some View {
        HStack {
            Picker("Часы", selection: $viewModel.selectedHour) {
                ForEach(viewModel.hours, id: \.self) { hour in
                    Text("\(hour) ч")
                }
            }
            .pickerStyle(WheelPickerStyle())

            Picker("Минуты", selection: $viewModel.selectedMinute) {
                ForEach(viewModel.minutes, id: \.self) { minute in
                    Text("\(minute) мин")
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
        .padding()
    }
}