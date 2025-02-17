import SwiftUI

struct SettingsTabView: View {
    var body: some View {
        ZStack {
            Color.clear
                .animatedGradientBackground()

            VStack {
                HeaderView()

                SettingsListView()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SettingsTabView()
}

struct AllOrderView: View {
    @State private var isShowingListOrder: Bool = false

    var body: some View {
        Button(action: {
            isShowingListOrder.toggle()
        }) {
            HStack {
                Image(systemName: "tray")
                Text("Все заказы")
            }

            .sheet(isPresented: $isShowingListOrder) {
                AllOrdersListView()
            }
        }
        .foregroundStyle(Color.white)
        .listRowBackground(Color.clear)
    }
}

import CoreData
import SwiftUI

struct AllOrdersListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        entity: Order.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Order.creationDate, ascending: false)]
    ) var orders: FetchedResults<Order>

    var body: some View {
        VStack {
            Text("Все заказы")
                .font(.largeTitle)
                .foregroundStyle(Color.white)
                .padding()

            List {
                ForEach(orders, id: \.id) { order in
                    VStack(alignment: .leading) {
                        Text("ID: \(order.id)")
                        Text("Цена: \(order.price)")
                        Text("Доступен: \(order.isAvailable ? "Да" : "Нет")")
                        Text("Дата создания: \(order.creationDate?.formatted() ?? "Не указано")")
                    }
                    .foregroundColor(.white)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let order = orders[index]
                        viewContext.delete(order)
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        print("Ошибка при удалении заказа: \(error)")
                    }
                }
            }
        }
    }
}
