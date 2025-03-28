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
                        ForEach(viewModel.orders, id: \.id) { order in
                            OrderRow(order: order)
                                .padding(.vertical, 8)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: viewModel.deleteOrder)
                    }
                    .scrollContentBackground(.hidden)
                }

                Spacer()
            }
        }
        .animatedGradientBackground()
    }
}
