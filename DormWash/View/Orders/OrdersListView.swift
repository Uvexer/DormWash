import SwiftUI

struct OrdersListView: View {
    @ObservedObject var viewModel: OrdersViewModel

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()

                    Text("Поставь таймер")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Spacer()
                }
                .padding(.top, 50)

                Spacer()

                if viewModel.orders.isEmpty {
                    VStack {
                        Image(systemName: "tray")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                        Text("Заказов нет")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                } else {
                    List {
                        ForEach(viewModel.orders.filter { $0.isAvailable }, id: \.id) { order in
                            OrderRow(order: order)
                                .padding(.vertical, 8)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete { indexSet in
                            let activeOrders = viewModel.orders.filter { $0.isAvailable }
                            let idsToDelete = indexSet.map { activeOrders[$0].id }
                            viewModel.deleteOrders(withIDs: Array(idsToDelete))
                        }
                    }
                    .scrollContentBackground(.hidden)
                }

                Spacer()
            }
        }
        .animatedGradientBackground()
    }
}
