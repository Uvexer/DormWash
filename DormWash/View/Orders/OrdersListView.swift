import SwiftUI

struct OrdersListView: View {
    @ObservedObject var viewModel: OrdersViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()

                    Text("Мои заказы")
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
    }
}
