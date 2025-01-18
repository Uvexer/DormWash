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

struct AllOrdersListView: View {
    var body: some View {
        Text("Все заказы")
            .font(.largeTitle)
            .foregroundStyle(Color.black.opacity(0.6))
            .padding()
        List {}
    }
}
