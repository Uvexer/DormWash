import UserNotifications
import SwiftUI
import CoreData

struct OrdersTabView: View {
    @State private var showMachineSelection = false
    @State private var selectedMachine: String = "Машинка 1"
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Order.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Order.id, ascending: true)]
    ) private var orders: FetchedResults<Order>
    
    let machines = ["Машинка 1", "Машинка 2", "Машинка 3", "Машинка 4", "Машинка 5", "Машинка 6", "Машинка 7", "Машинка 8"]
    let hours = Array(0..<24)
    let minutes = Array(0..<60)
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(orders) { order in
                        HStack {
                            Text(order.machine ?? "")
                            Spacer()
                            Text(orderTimeString(for: order))
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: deleteOrder)
                }
            }
            .navigationBarTitle("Заказы")
            .navigationBarItems(trailing: Button(action: {
                showMachineSelection.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showMachineSelection) {
                VStack {
                    Text("Выбери машинку")
                        .font(.largeTitle)
                    
                    Picker("Выберите машинку", selection: $selectedMachine) {
                        ForEach(machines, id: \.self) { machine in
                            Text(machine)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .padding()

                    HStack {
                        Picker("Часы", selection: $selectedHour) {
                            ForEach(hours, id: \.self) { hour in
                                Text("\(hour) ч")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        
                        Picker("Минуты", selection: $selectedMinute) {
                            ForEach(minutes, id: \.self) { minute in
                                Text("\(minute) мин")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    .padding()

                    Button(action: {
                        addOrder()
                        scheduleNotification()
                        showMachineSelection = false
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
            requestNotificationPermission()
        }
    }

    func addOrder() {
        let newOrder = Order(context: viewContext)
        newOrder.id = Int64(orders.count + 1)
        newOrder.machine = selectedMachine
        newOrder.hour = Int16(selectedHour)
        newOrder.minute = Int16(selectedMinute)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteOrder(at offsets: IndexSet) {
        offsets.map { orders[$0] }.forEach(viewContext.delete)
        
        do {
            try viewContext.save()
        } catch {
            // handle error
        }
    }

    func orderTimeString(for order: Order) -> String {
        let hour = String(format: "%02d", order.hour)
        let minute = String(format: "%02d", order.minute)
        return "\(hour):\(minute)"
    }
    
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Время вышло!"
        content.body = "Ваш заказ для \(selectedMachine) завершен."

        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: calculateTimeInterval(), repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка планирования уведомления: \(error.localizedDescription)")
            }
        }
    }
    
    func calculateTimeInterval() -> TimeInterval {
        let currentDate = Date()
        var components = DateComponents()
        components.hour = selectedHour
        components.minute = selectedMinute
        
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: components, to: currentDate) ?? currentDate
        return futureDate.timeIntervalSince(currentDate)
    }
}
