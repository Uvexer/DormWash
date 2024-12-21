import SwiftUI
import CoreData

struct OrdersTabView: View {
    @StateObject private var viewModel: OrdersViewModel

    init(viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: OrdersViewModel(viewContext: viewContext))
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.orders, id: \.id) { order in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(order.machine)
                                    .font(.headline)
                                Text(orderTimeString(for: order))
                                    .foregroundColor(.gray)
                                if order.isAvailable {
                                    Text("Доступно")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                } else {
                                    Text("Недоступно")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            Spacer()
                            Text("\(order.price) ₽")
                                .font(.headline)
                        }
                    }
                    .onDelete(perform: viewModel.deleteOrder)
                }
            }
            .navigationBarTitle("Поставь таймер")
            .navigationBarItems(trailing: Button(action: {
                viewModel.showMachineSelection.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $viewModel.showMachineSelection) {
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

                    Button(action: {
                        viewModel.addOrder()
                        viewModel.scheduleNotification()
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
        .onAppear {
            viewModel.requestNotificationPermission()
        }
    }

    private func orderTimeString(for order: OrderModel) -> String {
        let hour = String(format: "%02d", order.hour)
        let minute = String(format: "%02d", order.minute)
        return "\(hour):\(minute)"
    }
}

